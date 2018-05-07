#include "ros/ros.h"
#include <sensor_msgs/JointState.h>
#include <tf/transform_broadcaster.h>
#include <nav_msgs/Odometry.h>

long dist_trav_left_f = 0;
long dist_trav_left_b = 0;
long dist_trav_right_f = 0;
long dist_trav_right_b = 0;
current_time = ros::Time::now().toSec();

// <xacro:property name="wheelbase" value="0.5120" />
//<xacro:property name="track" value="0.5708" />
double distance_btw_wheels =0.5120;
double wheel_radius = 0.1651 ;


double x;
double y;
double th;

double vx;
double vy;
double vth;
double deltaLeft;
double deltaRight;

double diff_left_f;
double diff_right_f;
double diff_left_r;
double diff_right_r;

double dist_trav_left_f;
double dist_trav_left_r;
double dist_trav_right_f;
double dist_trav_right_r;
//"front_left_wheel")("front_right_wheel")("rear_left_wheel")("rear_right_wheel");


void update_time()
{
	delta_time = ros::Time::now().toSec() - current_time;
	current_time = ros::Time::now().toSec();
}

void WheelCallback(const sensor_msgs::JointState::ConstPtr& msg)
{
double prev_dist_trav_left_f = double dist_trav_left_f;
double dist_trav_left_f = msg -> position[0];
double diff_left_f= double dist_trav_left_f - double prev_dist_trav_left_f;

double prev_dist_trav_right_f = double dist_trav_right_f;
double dist_trav_right_f = msg -> position[1];
double diff_right_f= double dist_trav_right_f - double prev_dist_trav_right_f;

double prev_dist_trav_left_r = double dist_trav_left_r;
double dist_trav_left_r= msg -> position[2];
double diff_left_r= double double dist_trav_left_r - double prev_dist_trav_left_r;

double prev_dist_trav_right_r = double dist_trav_right_r;
double dist_trav_right_r = msg -> position[3];
double diff_right_r= double double dist_trav_right_r - double prev_dist_trav_right_r;



  deltaLeft = (diff_left_f + diff_left_r)*wheel_radius/2;
  deltaRight = ;(diff_right_f + diff_right_r)*wheel_radius/2;

  vx = deltaLeft/delta_time; // (current_time_encoder - last_time_encoder).toSec();
  vy = deltaRight/delta_time; // (current_time_encoder - last_time_encoder).toSec();


}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "odometry_publisher");
  ros::NodeHandle n;
  ros::Subscriber sub = n.subscribe("joint_states", 100, WheelCallback);
  ros::Publisher odom_pub = n.advertise<nav_msgs::Odometry>("odom_raw", 50);
  tf::TransformBroadcaster odom_broadcaster;


  ros::Time current_time, last_time;
  current_time = ros::Time::now().toSec();
  last_time = ros::Time::now().toSec();


  ros::Rate r(1.0);
  while(n.ok()){

    current_time = ros::Time::now();

    //compute odometry given the velocities of the robot
    double dt = (current_time - last_time).toSec();
    double delta_x = (vx * cos(th) - vy * sin(th)) * dt;
    double delta_y = (vx * sin(th) + vy * cos(th)) * dt;
    double delta_th = vth * dt;

    x += delta_x;
    y += delta_y;
    th += delta_th;

    //since we dont have the IMU yet and the odometry is 6DOF we'll need a quaternion created from yaw
    geometry_msgs::Quaternion odom_quat = tf::createQuaternionMsgFromYaw(th);

    //first, we'll publish the transform over tf
    geometry_msgs::TransformStamped odom_trans;
    odom_trans.header.stamp = current_time;
    odom_trans.header.frame_id = "odom_raw";
    odom_trans.child_frame_id = "base_link";

    odom_trans.transform.translation.x = x;
    odom_trans.transform.translation.y = y;
    odom_trans.transform.translation.z = 0.0;
    odom_trans.transform.rotation = odom_quat;

    //send the transform
    odom_broadcaster.sendTransform(odom_trans);

    //next, we'll publish the odometry message over ROS
    nav_msgs::Odometry odom_raw;
    odom_raw.header.stamp = current_time;
    odom_raw.header.frame_id = "odom";

    //set the position
    odom_raw.pose.pose.position.x = x;
    odom_raw.pose.pose.position.y = y;
    odom_raw.pose.pose.position.z = 0.0;
    odom_raw.pose.pose.orientation = odom_quat;

    //set the velocity
    odom_raw.child_frame_id = "base_link";
    odom_raw.twist.twist.linear.x = vx;
    odom_raw.twist.twist.linear.y = vy;
    odom_raw.twist.twist.angular.z = vth;

    //publish the message
    odom_pub.publish(odom_raw);

    last_time = current_time;
    ros::SpinOnce();
    r.sleep();
  }
}

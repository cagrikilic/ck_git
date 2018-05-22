#include <ros/ros.h>
#include <std_msgs/Float64.h>
#include <husky_msgs/HuskyStatus.h>
#include <sensor_msgs/JointState.h>
#include <torquer/Num2.h>
    double right_driver_voltage=0.0;
    double right_driver_current=0.0;
    double left_driver_voltage=0.0;
    double left_driver_current=0.0;
    double front_left_ang_vel=0.0;
    double front_right_ang_vel=0.0;
    double rear_left_ang_vel=0.0;
    double rear_right_ang_vel=0.0;
    double left_ang_vel=0.0;
    double right_ang_vel=0.0;
    double left_driver_power=0.0;
    double right_driver_power=0.0;
    double left_driver_torque=0.0;
    double right_driver_torque=0.0;
    //float power();
    //float torque();
    //double right_driver_power=0.0;
class PowerAndTorque
{
public:
  PowerAndTorque()
  {
    //Topic you want to publish
    //pub_ = n_.advertise<PUBLISHED_MESSAGE_TYPE>("/published_topic", 1);
    pub_ = n_.advertise<torquer::Num2>("torqueMsg", 1);
    
    //Topic you want to subscribe
    //sub_ = n_.subscribe("/subscribed_topic", 1, &SubscribeAndPublish::callback, this);
    sub_1 = n_.subscribe("status", 1, &PowerAndTorque::PowerCallback, this);
    sub_2 = n_.subscribe("joint_states", 1, &PowerAndTorque::WheelCallback, this);
  }

//void callback(const SUBSCRIBED_MESSAGE_TYPE& input)
void PowerCallback(const husky_msgs::HuskyStatus::ConstPtr& msg)
  {
    //PUBLISHED_MESSAGE_TYPE output;
    torquer::Num2 power;
    
    //.... do something with the input and generate the output...
    right_driver_voltage=msg->right_driver_voltage;
	//ROS_INFO("right_driver_voltage: [%f]", right_driver_voltage);
    right_driver_current=msg->right_driver_current;
    right_driver_power=right_driver_voltage*right_driver_current;
	//ROS_INFO("right_driver_voltage: [%f]", power.right_driver_power);
    left_driver_voltage=msg->left_driver_voltage;
    left_driver_current=msg->left_driver_current;
    left_driver_power=left_driver_voltage*left_driver_current;
    power.left_driver_power=left_driver_power;
    power.right_driver_power=right_driver_power;
//ROS_INFO("power: [%f]", power);
    pub_.publish(power);  
}
void WheelCallback(const sensor_msgs::JointState::ConstPtr& msg)
{
 torquer::Num2 torque;
 front_left_ang_vel=msg->velocity[0];
 front_right_ang_vel=msg->velocity[1];
 rear_left_ang_vel=msg->velocity[2];
 rear_right_ang_vel=msg->velocity[3];
 left_ang_vel=(front_left_ang_vel+rear_left_ang_vel)/2.0;
 right_ang_vel=(front_right_ang_vel+rear_right_ang_vel)/2.0;
 left_driver_torque=left_driver_power/left_ang_vel;
 torque.left_driver_torque=left_driver_torque;
 right_driver_torque=right_driver_power/right_ang_vel;
 torque.right_driver_torque=right_driver_torque;
 pub_.publish(torque); 
}

private:
  ros::NodeHandle n_; 
  ros::Publisher pub_;
  ros::Subscriber sub_1;
  ros::Subscriber sub_2;
};//End of class PowerAndTorque

int main(int argc, char **argv)
{
  //Initiate ROS
  //ros::init(argc, argv, "subscribe_and_publish");std_msgs_listener
  ros::init(argc, argv, "std_msgs_listener");
  //Create an object of class SubscribeAndPublish that will take care of everything
  PowerAndTorque SAPObject;

  ros::spinOnce();

  return 0;
}


/*
void PowerCallback(const husky_msgs::HuskyStatus::ConstPtr& msg)
{
right_driver_voltage=msg->right_driver_voltage;
right_driver_current=msg->right_driver_current;
right_driver_power=right_driver_voltage*right_driver_current;
//ROS_INFO("right_driver_power: [%f]", right_driver_power);

left_driver_voltage=msg->left_driver_voltage;
left_driver_current=msg->left_driver_current;
left_driver_power=right_driver_voltage*left_driver_current;
//ROS_INFO("left_driver_power: [%f]", left_driver_power);
}

void WheelCallback(const sensor_msgs::JointState::ConstPtr& msg)
{
 front_left_ang_vel=msg->velocity[0];
 front_right_ang_vel=msg->velocity[1];
 rear_left_ang_vel=msg->velocity[2];
 rear_right_ang_vel=msg->velocity[3];
 left_ang_vel=(front_left_ang_vel+rear_left_ang_vel)/2.0;
 right_ang_vel=(front_right_ang_vel+rear_right_ang_vel)/2.0;
   torque_left=left_driver_power/left_ang_vel;
   torque_right=right_driver_power/right_ang_vel;
//figure out that the power is always zero so it sees the initial value only.
  ROS_INFO("left_driver_power: [%f]", left_driver_power);
  ROS_INFO("left_wheels_ang_vel: [%f]", left_ang_vel);
  //ROS_INFO("torque_left: [%f]", torque_left);
  //ROS_INFO("torque_right: [%f]", torque_right);
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "std_msgs_listener");

  ros::NodeHandle n;
  ros::Subscriber sub1 = n.subscribe("status", 1, PowerCallback);
  ros::Subscriber sub2 = n.subscribe("joint_states", 1, WheelCallback);
  //ROS_INFO("left_driver_power: [%f]", left_driver_power);
  //ROS_INFO("left_wheels_ang_vel: [%f]", left_ang_vel);
ros::spin();

  return 0;

}
*/

require 'yaml'

$num_breadcrumbs = 12

def spawner(_name, _modelURI, _worldName, _x, _y, _z, _roll, _pitch, _yaw)
  base_spawn = `rospack find ctu_cras_norlab_absolem_sensor_config_1`.chomp + "/launch/common.rb"

  begin
    load base_spawn
  rescue LoadError
    raise "Unknown robot configuration #{_modelURI}. #{base_spawn} could not be found."
  else
    _additionalSDF = <<-HEREDOC
      <plugin filename="ignition-gazebo-breadcrumbs-system" name="ignition::gazebo::systems::Breadcrumbs">
        <topic>/model/#{_name}/breadcrumb/deploy</topic>
        <max_deployments>#{$num_breadcrumbs}</max_deployments>
        <disable_physics_time>3.0</disable_physics_time>
        <topic_statistics>true</topic_statistics>
        <breadcrumb>
          <sdf version="1.6">
            <model name="#{_name}__breadcrumb__">
              <pose>-0.45 0 0 0 0 0</pose>
              <include>
                <uri>https://fuel.ignitionrobotics.org/1.0/OpenRobotics/models/Breadcrumb Node</uri>
             </include>
           </model>
         </sdf>
       </breadcrumb>
      </plugin>
    HEREDOC
    _spawner(_name, _modelURI, _worldName, _x, _y, _z, _roll, _pitch, _yaw, _additionalSDF)
  end
end

def rosExecutables(_name, _worldName)
  <<-HEREDOC
  <executable name='topics'>
    <command>roslaunch --wait ctu_cras_norlab_absolem_sensor_config_1 vehicle_topics.launch world_name:=#{_worldName} name:=#{_name} breadcrumbs:=1</command>
  </executable>
  HEREDOC
end

#! /bin/bash

nova-dsl <<EOF1

provision 'my new task' do
   image 324
   flavor 2
end

EOF1
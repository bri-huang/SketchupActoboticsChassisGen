#!/usr/bin/env ruby

# First we pull in the standard API hooks.
require 'sketchup.rb'

# Show the Ruby Console at startup so we can
# see any programming errors we may make.
# Sketchup.send_action "showRubyPanel:"


# Add a menu item to launch our plugin.
UI.menu("PlugIns").add_item("Create Actobotics Channel") {
  defaults = ["12 inches"]
  prompts  = ["How long is the C-Channel? "]
  list     = ["1.5 inches|3.0 inches|4.5 inches|6.0 inches|9.0 inches|12.0 inches|15.0 inches|18.0 inches|24.0 inches"]
  input    = UI.inputbox prompts, defaults, list, "Select the c-channel length to create."

  sections = {
    "1.5"  => 1,
    "3.0"  => 2,
    "4.5"  => 3,
    "6.0"  => 4,
    "9.0"  => 6,
    "12.0" => 8,
    "15.0" => 10,
    "18.0" => 12,
    "24.0" => 16
  };

  if sections[input[0]].nil?
    UI.messagebox( "You gave me #{input} -- I have no idea what to do with that.")
  end

  # Call our new method.
  makeSides(sections[input[0]])
}

def makeSides(numSections)
  model = Sketchup.active_model
  entities = model.entities
  sel = model.selection
  vector = Geom::Vector3d.new 0,0,1  # sets the orientation of plane

  x0 = 0.75
  y0 = 0.75
  z0 = 0
  radius = 0.25

  ## clear screen
  #while entities.count > 0 do
  # entities.each do |e|
  #    entities.erase_entities e
  # end
  #end

  pt1 = [0, 0, z0]
  pt2 = [0, 0 + 1.5, z0]
  pt3 = [1.5*(numSections), 1.5, z0]
  pt4 = [1.5*(numSections), 0, z0]


  # Call methods on the Entities collection to draw stuff.
  new_face = entities.add_face pt1, pt2, pt3, pt4
  outer_hole_offset = 0.75/Math.sqrt(2)
  inner_hole_offset = 0.385/Math.sqrt(2)

  circle = entities.add_circle [inner_hole_offset,y0 + inner_hole_offset,0], vector, 0.07
  entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
  circle = entities.add_circle [inner_hole_offset,y0 - inner_hole_offset,0], vector, 0.07
  entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
  for n in 0..(2*numSections - 2)
    x0 = 0.75 + 0.75*n

    circle = entities.add_circle [x0,y0,0], vector, radius
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 - 0.375,y0,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 + 0.375,y0,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    angle_ndx = []
    angle_ndx = [1, 2, 3, 5, 6, 7]

    radius2 = 0.770 / 2

    angle_ndx.each do |ndx|
      angle = ndx*2*Math::PI/8
      circle = entities.add_circle [x0+radius2*Math.cos(angle),y0+radius2*Math.sin(angle),0], vector, 0.07
      entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    end

    circle = entities.add_circle [x0 + outer_hole_offset,y0 + outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 + outer_hole_offset,y0 - outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 + outer_hole_offset - 0.75,y0 + outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 + outer_hole_offset - 0.75,y0 - outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face

    circle = entities.add_circle [x0 - outer_hole_offset,y0 + outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 - outer_hole_offset,y0 - outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 - outer_hole_offset + 0.75,y0 + outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
    circle = entities.add_circle [x0 - outer_hole_offset + 0.75,y0 - outer_hole_offset,0], vector, 0.07
    entities.erase_entities entities[entities.count - 1] if entities[entities.count - 1].is_a? Sketchup::Face
  end

  x0 = 0.75 + 0.75*(n+1)

  circle = entities.add_circle [x0 - inner_hole_offset,y0 + inner_hole_offset,0], vector, 0.07
  entities.erase_entities entities[entities.count - 1]
  circle = entities.add_circle [x0 - inner_hole_offset,y0 - inner_hole_offset,0], vector, 0.07
  entities.erase_entities entities[entities.count - 1]

  # Clear out the holes

  #  entities[entities.count-1]
  #  entities.each do |e|
  #    faces << e if e.is_a? Sketchup::Face
  #  end

  #for n in 1..(faces.size - 1)
  #  entities.erase_entities faces[n]
  #end

  faces = entities[4]
  faces.pushpull(0.09)

  #all_entities = []
  #  entities.each do |e|
  #    all_entities << e
  #  end

  # Group Plate into an object
  #group = entities.add_group(all_entities)
  #group.name = "C Channel Plate"
end

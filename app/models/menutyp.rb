class Menutyp < ActiveRecord::Base
  @@CACHE_KEY="MENUTYP"

  def self.current(key)
    Rails.cache.write(@@CACHE_KEY, Menutyp.all) if Rails.cache.read(@@CACHE_KEY).nil?
    Rails.cache.read(@@CACHE_KEY).find_all{|r|r.key == key}.first || Menutyp.new
  end

  def self.menus typcd
    Menutyp.where({:typcd=> typcd}).all
  end

  def self.menusc par
    Menutyp.where({:typcd=> 'C',:parent=> par}).all
  end

  def subitems_c
    Menutyp.order('`key`').where({:parent=> key,:typcd=> 'C'}).all
  end

  def subitems_b
    Menutyp.where({:parent=> key,:typcd=> 'B'}).all
  end

  def superior
    Menutyp.find_by_key parent
  end

  def self.flat_show
    Menutyp.where({:typcd=> 'B'}).all.each.map do |item|
      {
        :key=>"#{item.parent}-#{item.key}",
        :sdesc=>"#{item.parent ? item.superior.sdesc + ' - ' : ''}#{item.sdesc}"
      }
    end
  end

  def self.home root
    (_item = Menutyp.where({:key=> root,:typcd=> 'B'}).first).nil? ? '' : _item.home
  end
end

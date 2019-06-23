class Project < ApplicationRecord
  attr_accessor :previous_header_id
  #belongs_to :project_draft

  after_destroy :clean_header
  #after_save :clean_image_dimensions

  #mount_uploaders :images, ProjectImageUploader
  mount_uploader  :icon,   ProjectIconUploader

  validates :name, presence: true, length: { maximum: 128 },
    uniqueness: { case_sensitive: false }
  validate :content_yaml_check

  #validate :image_size_validation
  validates_processing_of :icon
  validate :icon_size_validation

  #if Rails.env = "development"
    # workaround for json independent database
  #  serialize :images, JSON
  #  serialize :image_dimensions, JSON
  #end

  def clean_header_update
    if Project.where(project_header_id: self.previous_header_id).count == 0
      if header = ProjectHeader.find_by(id: self.previous_header_id)
        header.delete
      end
    end
  end 

  private

  def content_yaml_check
    #/\A---$(.+)^---/m =~ self.content
    /\A---(.+)---/m =~ self.draft
    if $~
      if $~.to_s.include? "!ruby"
        self.errors.add :draft, "Invalid YAML frontmatter"
      else
        data = YAML.load($~.to_s)
        if data.is_a?(Hash)
          if (data.has_key?("header")) == false ||
              data.size > 1
            self.errors.add :content, "Invalid YAML keys(invalid hash)"
          end
        else
            self.errors.add :content, "Invalid YAML keys(not a hash)"
        end

      end
    else
      self.errors.add :content, "Invalid YAML frontmatter"
    end
  end

    #def clean_image_dimensions
    #  if image_dimensions
    #    if images
    #      remove_c = image_dimensions.size - images.size
    #      if remove_c > 0
    #        self.image_dimensions = image_dimensions.drop(remove_c)
    #        self.save
    #      end
    #    else
    #      self.image_dimensions = nil
    #      self.save
    #    end
    #  end
    #end

    def clean_header
      if Project.where(project_header_id: self.project_header_id).count == 0
        if header = ProjectHeader.find_by(id: self.project_header_id)
          header.delete
        end
      end
    end 


    #def image_size_validation
    #  if images
    #    images.each do |img|
    #      if img.size > 1.megabytes
    #        errors.add(:images, "should be less than 500KB each")
    #      end
    #    end
    #  end
    #end

    def icon_size_validation
      if icon && icon.size > 0.3.megabytes
        errors.add(:icon, "should be less than 300KB")
      end
    end

  protected


end

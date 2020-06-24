# frozen_string_literal: true

class Web::LanguagesController < Web::ApplicationController
  def show
    @language = Language.find_by!(slug: params[:id])
    @modules = @language.current_modules
                        .includes(:module)
                        .order(:order)
                        .eager_load(:lesson_versions)
                        .merge(
                          Language::Module::Lesson::Version.includes(:lesson).order(:order)
                        )
    @descriptions_by_module = @language.module_descriptions
                                       .where(language_module_descriptions: { locale: I18n.locale })
                                       .index_by(&:module_id)
    @descriptions_by_lesson = @language.lesson_descriptions
                                       .where(language_module_lesson_descriptions: { locale: I18n.locale })
                                       .index_by(&:lesson_id)
  end
end
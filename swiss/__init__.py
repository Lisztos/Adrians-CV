from pathlib import Path
from rendercv.schema.models.design.classic_theme import ClassicTheme
from rendercv.schema.variant_pydantic_model_generator import (
    create_variant_pydantic_model,
)
from rendercv.schema.yaml_reader import read_yaml

SwissTheme = create_variant_pydantic_model(
    variant_name="swiss",
    defaults=read_yaml(Path(__file__).parent / "swiss.yaml")["design"],
    base_class=ClassicTheme,
    discriminator_field="theme",
    class_name_suffix="Theme",
    module_name=__name__,
)

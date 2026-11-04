from hypothesis import given, settings
import hypothesis.strategies as st
from app.text import display_initials

@settings(max_examples=300, deadline=None)
@given(full_name=st.text())
def test_display_initials_never_crashes(full_name):
    display_initials(full_name)

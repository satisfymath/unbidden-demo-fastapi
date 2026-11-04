"""Small text helpers for what the frontend displays."""


def display_initials(full_name: str) -> str:
    """The initials shown on a person's avatar: first and last name."""
    words = full_name.split(" ")
    return (words[0][0] + words[-1][0]).upper()

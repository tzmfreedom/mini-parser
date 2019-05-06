class Value {
    public Node original;
    public String value;

    public Value(String value, Node original) {
        this.value = value;
        this.original = original;
    }

    public Integer getInteger() {
        return Integer.valueOf(this.value);
    }

    public String getString() {
        return this.value;
    }
}

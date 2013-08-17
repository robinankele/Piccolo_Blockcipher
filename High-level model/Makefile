CXX = gcc
CXXFLAGS = -c -Wall -g
LDFLAGS =
SOURCES = $(wildcard *.c)
OBJECTS = ${SOURCES:.c=.o}
TITLE = piccolo
ARCHIVE = $(TITLE).tar.gz

.PHONY : all clean valgrind archive

all: $(TITLE)

$(TITLE) : $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJECTS)

%.o : %.c
	$(CXX) $(CXXFLAGS) -o $@ $< -MMD -MF ./$@.d
    
run :
	time ./$(TITLE)
    
encrypt :
	time ./$(TITLE) -p "0123456789abcdef" -k "0011 2233445566778899"
    
decrypt :
	time ./$(TITLE) -c "8d2bff9935f84056" -k "0011 2233445566778899"

clean :
	rm -f *.o  $(TITLE) *.d
  
valgrind : $(TITLE)
	valgrind --tool=memcheck --leak-check=yes ./$< $(P0) $(P1)

archive :
	tar cfz $(ARCHIVE) *.c *.h *.pdf $(TITLE)

-include $(wildcard ./*.d)
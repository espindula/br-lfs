Onward branch:

October 4rth, 2008

Hardened LinuxFromScratch was born on the lfs-security mailing list in late
2003. The philosophy is based on learning, one step at a time, 
how to harden a Linux system. This was something that was traditionally left
to someone else, such as Hardened Gentoo
(http://www.gentoo.org/proj/en/hardened/), Owl Linux
(http://www.openwall.com/Owl/), OpenBSD (http://www.openbsd.org/), and others.
This was unsatisfying to a do-it-yourselfer, and so Hardened LinuxFromScratch
emerged.

The ProPolice and PIE LFS hints paved the way, and it became apparent that a
new book was more practical than following multiple LFS hints. 
The majority of changes and additions were to the toolchain (GCC, Binutils,
the C library, and the Linux kernel), and how packages were compiled. Although
it is part of the scope of Hardened LinuxFromScratch, the setup of packages
(especially network) has been neglected. In general HLFS has taken the
initiative, when feasible, to fix system vulnerabilities, and is not following
or directed by any outside project.

Unlike distributions who have to maintain reverse compatibility, HLFS is from
scratch and can redesign itself at any time, if there's a reason to. This
advantage has been embraced. Anything can be removed, changed, or added,
without regard to previous versions, because each build is bootstrapped.

A stable version of the book has been in reach several times, but has always
been pushed aside for further advancement and new features. Since 2003, Stack
Smashing Protector (http://www.trl.ibm.com/projects/security/ssp/), PaX
(http://pax.grsecurity.net/) compliance, Grsecurity
(http://www.grsecurity.net/), run-time string buffer overflow detection
(http://gcc.gnu.org/ml/gcc-patches/2004-09/msg02055.html), Linux Posix
capabilities
(http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/), and
various other additions have been integrated to the build.

During 2008 the Linux kernel added file attributes for posix capabilities,
which were integrated with HLFS (in the Shadow package). This caused a
dependency on a new kernel, and was adopted as an opportunity to eliminate
host system dependencies by adding a reboot after the temporary tools are
installed. In turn, this added complications. An html book could not be read
without an html viewer in the rebooted system, so a simpler solution was plain
text. A plain text book can be run as shell scripts for convenience.

Additionally, both LFS and HLFS have come to recognize that it is unacceptable
for package management to be completely neglected. From the standpoint of HLFS,
this issue is with file management, rather than package management, but the
two are closely related. A responsible administrator should account for each
file, where it came from, and what its purpose is. Furthermore, with posix
capabilities, it is more secure if root does not own any files on the system,
because a process running as root without the FOWNER capability would be
unable to overwrite files not owned by root, and this would make it more
difficult for root to be exploited.

A two user package/file management system was found to be the most practical
solution. This means new packages are installed by an admin-helper. The
package's installed files are recorded, and the ownership is changed to the
admin. This stops new packages from overwriting the files of another package,
allows us to catalog installed package files (so ownership can be reverted for
upgrades), and disallows root from modifying them without the FOWNER
capability. A multi-user package management system (such as the
more_control_and_pkg_man.txt LFS hint) was found to be overly complicated,
and has no advantage over the two user system.

More recently, chroot additions are being considered where ever possible.

As a result of all this, the HLFS book is in a state of change, and has
stopped development of the xml/html book until things become decided. The book
and build system are becoming integrated, and so everything needs to be
thought through before the new Onward branch can be written.

robert

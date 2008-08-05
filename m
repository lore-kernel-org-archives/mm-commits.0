From: akpm@linux-foundation.org
Subject: + docbook-fix-s390-fatal-error-after-header-files-moved.patch added to -mm tree
Date: Tue, 05 Aug 2008 15:13:57 -0700
Message-ID: <200808052213.m75MDvlS026166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYHEWPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 18:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, schwidefsky@de.ibm.com


The patch titled
     docbook: fix s390 fatal error after header files moved
has been added to the -mm tree.  Its filename is
     docbook-fix-s390-fatal-error-after-header-files-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix s390 fatal error after header files moved
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix (fatal error) s390 docbook file to handle renamed header files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/s390-drivers.tmpl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/DocBook/s390-drivers.tmpl~docbook-fix-s390-fatal-error-after-header-files-moved Documentation/DocBook/s390-drivers.tmpl
--- a/Documentation/DocBook/s390-drivers.tmpl~docbook-fix-s390-fatal-error-after-header-files-moved
+++ a/Documentation/DocBook/s390-drivers.tmpl
@@ -100,7 +100,7 @@
       the hardware structures represented here, please consult the Principles
       of Operation.
     </para>
-!Iinclude/asm-s390/cio.h
+!Iarch/s390/include/asm/cio.h
     </sect1>
     <sect1 id="ccwdev">
      <title>ccw devices</title>
@@ -114,7 +114,7 @@
       ccw device structure. Device drivers must not bypass those functions
       or strange side effects may happen.
     </para>
-!Iinclude/asm-s390/ccwdev.h
+!Iarch/s390/include/asm/ccwdev.h
 !Edrivers/s390/cio/device.c
 !Edrivers/s390/cio/device_ops.c
     </sect1>
@@ -125,7 +125,7 @@
 	measurement data which is made available by the channel subsystem
 	for each channel attached device.
   </para>
-!Iinclude/asm-s390/cmb.h
+!Iarch/s390/include/asm/cmb.h
 !Edrivers/s390/cio/cmf.c
     </sect1>
   </chapter>
@@ -142,7 +142,7 @@
   </para>
    <sect1 id="ccwgroupdevices">
     <title>ccw group devices</title>
-!Iinclude/asm-s390/ccwgroup.h
+!Iarch/s390/include/asm/ccwgroup.h
 !Edrivers/s390/cio/ccwgroup.c
    </sect1>
   </chapter>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-skip-nested-struct-union-cleanly.patch
docbook-fix-s390-fatal-error-after-header-files-moved.patch
linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file.patch
bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch


From: akpm@linux-foundation.org
Subject: + rapidio-fix-docbook-references.patch added to -mm tree
Date: Mon, 17 Mar 2008 19:29:48 -0700
Message-ID: <200803180229.m2I2TmnF010094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYCRCaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 22:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mporter@kernel.crashing.org, wei.zhang@freescale.com


The patch titled
     rapidio: fix docbook references
has been added to the -mm tree.  Its filename is
     rapidio-fix-docbook-references.patch

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
Subject: rapidio: fix docbook references
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix rapidio docbook (file was removed) and fix header file kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zhang Wei <wei.zhang@freescale.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/rapidio.tmpl |    1 -
 include/linux/rio.h                |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/DocBook/rapidio.tmpl~rapidio-fix-docbook-references Documentation/DocBook/rapidio.tmpl
--- a/Documentation/DocBook/rapidio.tmpl~rapidio-fix-docbook-references
+++ a/Documentation/DocBook/rapidio.tmpl
@@ -133,7 +133,6 @@
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
      <sect1 id="PPC32_support"><title>PPC32 support</title>
-!Iarch/powerpc/kernel/rio.c
 !Earch/powerpc/sysdev/fsl_rio.c
 !Iarch/powerpc/sysdev/fsl_rio.c
      </sect1>
diff -puN include/linux/rio.h~rapidio-fix-docbook-references include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-docbook-references
+++ a/include/linux/rio.h
@@ -327,7 +327,7 @@ struct rio_route_ops {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem - struct for RIO memory definition.
  * @node: Node in list of memories
  * @virt: The virtual address for mapped memory accessing.
  * @owner: The owner id of this memory.
@@ -346,7 +346,7 @@ struct rio_mem {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem_ops - Struct for RIO memory operations definition.
  * @map_inb: The function for mapping inbound memory window.
  * @map_outb: The function for mapping outbound memory window.
  * @unmap_inb: The function for unmapping inbound memory window.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
x86-convert-mtrr-genericc-to-kernel-doc.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
profile-likely-unlikely-macros.patch


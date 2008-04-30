From: akpm@linux-foundation.org
Subject: + docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:26:52 -0700
Message-ID: <200804301826.m3UIQqVQ028379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758599AbYD3S1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:27:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: fix fatal rapidio yet again (and more to come)
has been added to the -mm tree.  Its filename is
     docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch

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
Subject: docbook: fix fatal rapidio yet again (and more to come)
From: Randy Dunlap <randy.dunlap@oracle.com>

Don't refer to file that no longer exists:
docproc: linux-2.6.25-git14/arch/powerpc/kernel/rio.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/rapidio.tmpl |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/DocBook/rapidio.tmpl~docbook-fix-fatal-rapidio-yet-again-and-more-to-come Documentation/DocBook/rapidio.tmpl
--- a/Documentation/DocBook/rapidio.tmpl~docbook-fix-fatal-rapidio-yet-again-and-more-to-come
+++ a/Documentation/DocBook/rapidio.tmpl
@@ -133,7 +133,6 @@
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
      <sect1 id="PPC32_support"><title>PPC32 support</title>
-!Iarch/powerpc/kernel/rio.c
 !Earch/powerpc/sysdev/fsl_rio.c
 !Iarch/powerpc/sysdev/fsl_rio.c
      </sect1>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch
docbook-fix-vmalloc-missing-parameter-notation.patch


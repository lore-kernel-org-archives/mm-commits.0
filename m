From: akpm@linux-foundation.org
Subject: - doc-what-a-patch-series-is.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:26 -0700
Message-ID: <200705092150.l49LoQAK002806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326AbXEIVuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: what a patch series is
has been removed from the -mm tree.  Its filename was
     doc-what-a-patch-series-is.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc: what a patch series is
From: Randy Dunlap <randy.dunlap@oracle.com>

It seems that we need to clarify that a patch series is a series of related
patches rather than "here are some of my patches as multiple (numbered)
emails."

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~doc-what-a-patch-series-is Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~doc-what-a-patch-series-is
+++ a/Documentation/SubmittingPatches
@@ -363,7 +363,8 @@ area or subsystem of the kernel is being
 The "summary phrase" in the email's Subject should concisely
 describe the patch which that email contains.  The "summary
 phrase" should not be a filename.  Do not use the same "summary
-phrase" for every patch in a whole patch series.
+phrase" for every patch in a whole patch series (where a "patch
+series" is an ordered sequence of multiple, related patches).
 
 Bear in mind that the "summary phrase" of your email becomes
 a globally-unique identifier for that patch.  It propagates
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ocfs2-kobject-kset-foobar.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
profile-likely-unlikely-macros.patch

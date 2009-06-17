From: akpm@linux-foundation.org
Subject: [folded] documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:46:22 -0700
Message-ID: <200906172246.n5HMkMsh006529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758290AbZFQWqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jluis@escomposlinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     documentation-changes-perl-is-needed-to-build-the-kernel-fix
has been removed from the -mm tree.  Its filename was
     documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch

This patch was dropped because it was folded into documentation-changes-perl-is-needed-to-build-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation-changes-perl-is-needed-to-build-the-kernel-fix
From: Andrew Morton <akpm@linux-foundation.org>

80-columns, please.

Cc: Jose Luis Perez Diez <jluis@escomposlinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Changes |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel-fix Documentation/Changes
--- a/Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel-fix
+++ a/Documentation/Changes
@@ -74,8 +74,8 @@ release of binutils.
 Perl
 ----
 
-You will need perl 5 and the following modules: Getopt::Long, Getopt::Std, File::Basename, and File::Find to build the kernel.
-
+You will need perl 5 and the following modules: Getopt::Long, Getopt::Std,
+File::Basename, and File::Find to build the kernel.
 
 
 System utilities
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch


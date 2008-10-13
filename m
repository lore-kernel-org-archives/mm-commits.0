From: akpm@linux-foundation.org
Subject: - mn10300-mei-are-renaming-themselves-to-panasonic.patch removed from -mm tree
Date: Mon, 13 Oct 2008 05:05:00 -0700
Message-ID: <200810131204.m9DC4ehh013325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756756AbYJMMF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Oct 2008 08:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: MEI are renaming themselves to Panasonic
has been removed from the -mm tree.  Its filename was
     mn10300-mei-are-renaming-themselves-to-panasonic.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MN10300: MEI are renaming themselves to Panasonic
From: David Howells <dhowells@redhat.com>

MEI are renaming themselves to Panasonic, so update the MAINTAINERS record
for the MN10300 arch.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~mn10300-mei-are-renaming-themselves-to-panasonic MAINTAINERS
--- a/MAINTAINERS~mn10300-mei-are-renaming-themselves-to-panasonic
+++ a/MAINTAINERS
@@ -2796,7 +2796,7 @@ L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-MEI MN10300/AM33 PORT
+PANASONIC MN10300/AM33 PORT
 P:	David Howells
 M:	dhowells@redhat.com
 P:	Koichi Yasutake
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-tip.patch
git-v4l-dvb.patch
git-xfs.patch
git-mtd.patch
git-cifs.patch
git-drm.patch
git-security-testing.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
mn10300-mei-are-renaming-themselves-to-panasonic.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
sysctl-simplify-strategy.patch
afs-convert-to-new-aops.patch
afs-convert-to-new-aops-update.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch


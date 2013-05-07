From: akpm@linux-foundation.org
Subject: [merged] uapi-remove-empty-kbuild-files.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:05 -0700
Message-ID: <20130507175105.6F67831C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52954 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EGRvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:06 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so86589vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: remove empty Kbuild files
has been removed from the -mm tree.  Its filename was
     uapi-remove-empty-kbuild-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: remove empty Kbuild files

Remove empty Kbuild files as they cause problems with the patch program which
removes files that become empty.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/Kbuild      |    3 ---
 include/scsi/Kbuild |    1 -
 2 files changed, 4 deletions(-)

diff -puN include/Kbuild~uapi-remove-empty-kbuild-files include/Kbuild
--- a/include/Kbuild~uapi-remove-empty-kbuild-files
+++ a/include/Kbuild
@@ -1,5 +1,2 @@
 # Top-level Makefile calls into asm-$(ARCH)
 # List only non-arch directories below

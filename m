From: akpm@linux-foundation.org
Subject: [merged] doc-fix-ext2-can-only-have-32000-subdirs-not-32768.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:49 -0700
Message-ID: <200906182244.n5IMinX1003898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758330AbZFRWou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mshields@google.com, mm-commits@vger.kernel.org


The patch titled
     Doc fix: ext2 can only have 32,000 subdirs, not 32,768
has been removed from the -mm tree.  Its filename was
     doc-fix-ext2-can-only-have-32000-subdirs-not-32768.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Doc fix: ext2 can only have 32,000 subdirs, not 32,768
From: Michael Shields <mshields@google.com>

ext2.txt says that dirs can have 32,768 subdirs, but the actual value of
EXT2_LINK_MAX is 32000.

ext3 is the same, but the doc does not mention it.  One of ext4's features
is to "fix 32000 subdirectory limit".


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ext2.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/ext2.txt~doc-fix-ext2-can-only-have-32000-subdirs-not-32768 Documentation/filesystems/ext2.txt
--- a/Documentation/filesystems/ext2.txt~doc-fix-ext2-can-only-have-32000-subdirs-not-32768
+++ a/Documentation/filesystems/ext2.txt
@@ -322,7 +322,7 @@ an upper limit on the block size imposed
 so 8kB blocks are only allowed on Alpha systems (and other architectures
 which support larger pages).
 
-There is an upper limit of 32768 subdirectories in a single directory.
+There is an upper limit of 32000 subdirectories in a single directory.
 
 There is a "soft" upper limit of about 10-15k files in a single directory
 with the current linear linked-list directory implementation.  This limit
_

Patches currently in -mm which might be from mshields@google.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-bogus-space.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:25 -0700
Message-ID: <543c1735.7ljIajznVdzhkLth%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaJMSRZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea.gelmini@gelma.net, anton@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: remove bogus space
has been removed from the -mm tree.  Its filename was
     ntfs-remove-bogus-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: ntfs: remove bogus space

fs/ntfs/debug.c:124: WARNING: space prohibited between function name and
open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ntfs/debug.c~ntfs-remove-bogus-space fs/ntfs/debug.c
--- a/fs/ntfs/debug.c~ntfs-remove-bogus-space
+++ a/fs/ntfs/debug.c
@@ -112,7 +112,7 @@ void __ntfs_error(const char *function,
 /* If 1, output debug messages, and if 0, don't. */
 int debug_msgs = 0;
 
-void __ntfs_debug (const char *file, int line, const char *function,
+void __ntfs_debug(const char *file, int line, const char *function,
 		const char *fmt, ...)
 {
 	struct va_format vaf;
_

Patches currently in -mm which might be from andrea.gelmini@gelma.net are

origin.patch


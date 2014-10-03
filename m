From: akpm@linux-foundation.org
Subject: + ntfs-remove-bogus-space.patch added to -mm tree
Date: Fri, 03 Oct 2014 12:09:13 -0700
Message-ID: <542ef459.UWo7Gf6cD76A2G5d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaJCTJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea.gelmini@gelma.net, anton@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: remove bogus space
has been added to the -mm tree.  Its filename is
     ntfs-remove-bogus-space.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-remove-bogus-space.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-remove-bogus-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-remove-bogus-space.patch


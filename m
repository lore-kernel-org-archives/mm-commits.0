From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch added to -mm tree
Date: Fri, 20 Sep 2013 14:15:54 -0700
Message-ID: <523cbb0a.Wpt06gvd1HQOFHiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3ITVPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 17:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, olof@lixom.net

Subject: + lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch added to -mm tree
To: olof@lixom.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 14:15:54 -0700


The patch titled
     Subject: lib/vsprintf.c: document formats for dentry and struct file
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: lib/vsprintf.c: document formats for dentry and struct file

Looks like these were added to Documentation/printk-formats.txt but
not the in-file table.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/vsprintf.c~lib-vsprintfc-document-formats-for-dentry-and-struct-file lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-document-formats-for-dentry-and-struct-file
+++ a/lib/vsprintf.c
@@ -1218,6 +1218,8 @@ int kptr_restrict __read_mostly;
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'd[234]' For a dentry name (optionally 2-4 last components)
+ * - 'D[234]' Same as 'd' but for a struct file
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
lib-vsprintfc-document-formats-for-dentry-and-struct-file.patch
linux-next.patch


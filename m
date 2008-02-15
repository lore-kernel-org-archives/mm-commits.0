From: akpm@linux-foundation.org
Subject: + mn10300-define-so_mark.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:22:58 -0800
Message-ID: <200802152022.m1FKMw8o022056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbYBOUXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     MN10300: define SO_MARK
has been added to the -mm tree.  Its filename is
     mn10300-define-so_mark.patch

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
Subject: MN10300: define SO_MARK
From: David Howells <dhowells@redhat.com>

Define SO_MARK for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/socket.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-mn10300/socket.h~mn10300-define-so_mark include/asm-mn10300/socket.h
--- a/include/asm-mn10300/socket.h~mn10300-define-so_mark
+++ a/include/asm-mn10300/socket.h
@@ -52,4 +52,6 @@
 #define SO_TIMESTAMPNS		35
 #define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
 
+#define SO_MARK			36
+
 #endif /* _ASM_SOCKET_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-define-hz-as-a-config-option.patch
mn10300-define-so_mark.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
inflate-refactor-inflate-malloc-code.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch

From: akpm@linux-foundation.org
Subject: + afs-add-a-maintainers-record-for-afs.patch added to -mm tree
Date: Tue, 25 Mar 2008 13:00:05 -0700
Message-ID: <200803252000.m2PK05NK010786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYCYUBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 16:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     afs: add a MAINTAINERS record for AFS
has been added to the -mm tree.  Its filename is
     afs-add-a-maintainers-record-for-afs.patch

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
Subject: afs: add a MAINTAINERS record for AFS
From: David Howells <dhowells@redhat.com>

Add a MAINTAINERS record for AFS.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~afs-add-a-maintainers-record-for-afs MAINTAINERS
--- a/MAINTAINERS~afs-add-a-maintainers-record-for-afs
+++ a/MAINTAINERS
@@ -163,6 +163,12 @@ M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 
+AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
+P:	David Howells
+M:	dhowells@redhat.com
+L:	linux-afs@lists.infradead.org
+S:	Supported
+
 AIO
 P:	Benjamin LaHaise
 M:	bcrl@kvack.org
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-add-a-maintainers-record-for-afs.patch
afs-prevent-double-cell-registration.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
mutex-subsystem-synchro-test-module.patch


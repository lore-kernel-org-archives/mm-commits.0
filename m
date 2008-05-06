From: akpm@linux-foundation.org
Subject: + omfs-add-maintainers-entry.patch added to -mm tree
Date: Tue, 06 May 2008 13:08:00 -0700
Message-ID: <200805062008.m46K80w4024925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764747AbYEFUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: me@bobcopeland.com


The patch titled
     omfs: add MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     omfs-add-maintainers-entry.patch

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
Subject: omfs: add MAINTAINERS entry
From: Bob Copeland <me@bobcopeland.com>

omfs: add MAINTAINERS entry

Add the MAINTAINERS entry for OMFS.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~omfs-add-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~omfs-add-maintainers-entry
+++ a/MAINTAINERS
@@ -3029,6 +3029,12 @@ W:	http://oss.oracle.com/projects/ocfs2/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 
+OMFS FILESYSTEM
+P:	Bob Copeland
+M:	me@bobcopeland.com
+L:	linux-karma-devel@lists.sourceforge.net
+S:	Maintained
+
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
_

Patches currently in -mm which might be from me@bobcopeland.com are

omfs-add-filesystem-documentation.patch
omfs-define-filesystem-structures.patch
omfs-add-inode-routines.patch
omfs-add-directory-routines.patch
omfs-add-file-routines.patch
omfs-add-bitmap-routines.patch
omfs-update-kbuild-to-include-omfs.patch
omfs-add-maintainers-entry.patch


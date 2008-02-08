From: akpm@linux-foundation.org
Subject: - email-clientstxt-sylpheed-is-ok-at-imap.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:38 -0800
Message-ID: <200802080802.m1882JXn014028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761910AbYBHIUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     email-clients.txt: sylpheed is OK at IMAP
has been removed from the -mm tree.  Its filename was
     email-clientstxt-sylpheed-is-ok-at-imap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: email-clients.txt: sylpheed is OK at IMAP
From: Randy Dunlap <randy.dunlap@oracle.com>

This comment is not helpful (no reason given) and is incorrect.
Just stick to facts that are useful regarding working on Linux.

(akpm: I've used sylpheed+imap for years)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/email-clients.txt~email-clientstxt-sylpheed-is-ok-at-imap Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~email-clientstxt-sylpheed-is-ok-at-imap
+++ a/Documentation/email-clients.txt
@@ -170,7 +170,6 @@ Sylpheed (GUI)
 
 - Works well for inlining text (or using attachments).
 - Allows use of an external editor.
-- Not good for IMAP.
 - Is slow on large folders.
 - Won't do TLS SMTP auth over a non-SSL connection.
 - Has a helpful ruler bar in the compose window.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch

From: akpm@linux-foundation.org
Subject: - oprofile-kernel-maintainership-changes.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:03 -0700
Message-ID: <200807141935.m6EJZ3Lu023864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbYGNTla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.richter@amd.com, akpm@linux-foundation.org, daniel.hansel@linux.vnet.ibm.com, jason.yeh@amd.com, levon@movementarian.org, maynardj@us.ibm.com, phil.el@wanadoo.fr, rpurdie@opene


The patch titled
     OProfile kernel maintainership changes
has been removed from the -mm tree.  Its filename was
     oprofile-kernel-maintainership-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OProfile kernel maintainership changes
From: Robert Richter <robert.richter@amd.com>

Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: Richard Purdie <rpurdie@openedhand.com>
Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
Cc: Jason Yeh <jason.yeh@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~oprofile-kernel-maintainership-changes MAINTAINERS
--- a/MAINTAINERS~oprofile-kernel-maintainership-changes
+++ a/MAINTAINERS
@@ -3082,8 +3082,8 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 OPROFILE
-P:	Philippe Elie
-M:	phil.el@wanadoo.fr
+P:	Robert Richter
+M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 
_

Patches currently in -mm which might be from robert.richter@amd.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:01 -0800
Message-ID: <200912152157.nBFLv1LQ015680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761291AbZLOV5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: mark cifs mailing list as "moderated for non-subscribers"
has been removed from the -mm tree.  Its filename was
     maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: mark cifs mailing list as "moderated for non-subscribers"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If non-subscribers post bug report to CIFS mailing list, they will get
following messages.

	Your mail to 'linux-cifs-client' with the subject

	    [PATCH x/x] cifs: xxxxxxxxxxxxx

	Is being held until the list moderator can review it for approval.

	The reason it is being held:

	    Post by non-member to a members-only list

	Either the message will get posted to the list, or you will receive
	notification of the moderator's decision.  If you would like to cancel
	this posting, please visit the following URL:

members-only list should be written as so in MAINTAINERS file.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers MAINTAINERS
--- a/MAINTAINERS~maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers
+++ a/MAINTAINERS
@@ -1482,8 +1482,8 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-L:	linux-cifs-client@lists.samba.org
-L:	samba-technical@lists.samba.org
+L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
+L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


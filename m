From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-chinese-documentation-maintainer.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:31 -0800
Message-ID: <201102282110.p1SLAV3f029312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab1B1VLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiaweiwei.xiyou@gmail.com, greg@kroah.com, harryxiyou@gmail.com, joe@perches.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add Chinese documentation maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-chinese-documentation-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add Chinese documentation maintainer
From: Harry Wei <jiaweiwei.xiyou@gmail.com>

I have translated some kernel documentation so I wish to maintain the
Chinese documentation in our kernel directories.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-chinese-documentation-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-chinese-documentation-maintainer
+++ a/MAINTAINERS
@@ -1692,6 +1692,13 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
+CHINESE DOCUMENTATION
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+L:	linux-kernel@zh-kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/zh_CN/
+
 CISCO VIC ETHERNET NIC DRIVER
 M:	Vasanthy Kolluri <vkolluri@cisco.com>
 M:	Roopa Prabhu <roprabhu@cisco.com>
_

Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are

origin.patch
linux-next.patch
maintainers-add-topgit-for-t.patch
documentation-codingstyle-flesh-out-if-else-examples.patch


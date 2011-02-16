From: akpm@linux-foundation.org
Subject: + maintainers-add-chinese-documentation-maintainer.patch added to -mm tree
Date: Wed, 16 Feb 2011 12:46:47 -0800
Message-ID: <201102162046.p1GKkmWB011461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388Ab1BPUwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Feb 2011 15:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiaweiwei.xiyou@gmail.com, greg@kroah.com, harryxiyou@gmail.com, joe@perches.com, randy.dunlap@oracle.com


The patch titled
     MAINTAINERS: add Chinese documentation maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-chinese-documentation-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
 M:	Christian Benvenuti <benve@cisco.com>
 M:	Vasanthy Kolluri <vkolluri@cisco.com>
_

Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
maintainers-add-topgit-for-t.patch


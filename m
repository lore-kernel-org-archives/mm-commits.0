From: akpm@linux-foundation.org
Subject: [merged] maintainers-kdump-maintainers-update.patch removed from
 -mm tree
Date: Tue, 31 May 2016 10:50:28 -0700
Message-ID: <574dcee4.waX01rJLNPBiFJMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbcEaRu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, hbabu@us.ibm.com, horms@verge.net.au, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Kdump maintainers update
has been removed from the -mm tree.  Its filename was
     maintainers-kdump-maintainers-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: MAINTAINERS: Kdump maintainers update

I am proposing following updates to kdump maintainership.  I have got busy
in other things and not getting time to spend on kdump.

Remove Haren Myneni as he has not participated in kdump development for a
long time now.

Add the names of Dave and Baoquan as kdump maintainers as they have been
contributing to kdump for a long time now and they are in a much better
position to spend time on this than me.

Mark myself as a reviewer.

Link: http://lkml.kernel.org/r/20160525131616.GB27291@redhat.com
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-kdump-maintainers-update MAINTAINERS
--- a/MAINTAINERS~maintainers-kdump-maintainers-update
+++ a/MAINTAINERS
@@ -6413,8 +6413,9 @@ F:	Documentation/kbuild/kconfig-language
 F:	scripts/kconfig/
 
 KDUMP
-M:	Vivek Goyal <vgoyal@redhat.com>
-M:	Haren Myneni <hbabu@us.ibm.com>
+M:	Dave Young <dyoung@redhat.com>
+M:	Baoquan He <bhe@redhat.com>
+R:	Vivek Goyal <vgoyal@redhat.com>
 L:	kexec@lists.infradead.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
_

Patches currently in -mm which might be from vgoyal@redhat.com are



From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-git-url-entry-for-uio.patch removed from -mm tree
Date: Tue, 27 Jan 2015 12:22:39 -0800
Message-ID: <54c7f38f.RrxNRIsWIfpYxWse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbA0UWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mandeep.sandhu@cyaninc.com, gregkh@linuxfoundation.org, hjk@hansjkoch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git url entry for UIO
has been removed from the -mm tree.  Its filename was
     maintainers-add-git-url-entry-for-uio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: MAINTAINERS: add git url entry for UIO

Added git url for UIO section.

Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-entry-for-uio MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-entry-for-uio
+++ a/MAINTAINERS
@@ -10245,6 +10245,7 @@ USERSPACE I/O (UIO)
 M:	"Hans J. Koch" <hjk@hansjkoch.de>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
_

Patches currently in -mm which might be from mandeep.sandhu@cyaninc.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-iio-include-files.patch removed from -mm tree
Date: Mon, 17 Nov 2014 12:51:05 -0800
Message-ID: <546a5fb9.O/7T8OHotFqkalpf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaKQUvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, cristina.ciocan@intel.com, jg1.han@samsung.com, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add IIO include files
has been removed from the -mm tree.  Its filename was
     maintainers-add-iio-include-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: MAINTAINERS: add IIO include files

Files under include/linux/iio were not reported as part of the IIO
subsystem.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reported-by: Cristina Ciocan <cristina.ciocan@intel.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-iio-include-files MAINTAINERS
--- a/MAINTAINERS~maintainers-add-iio-include-files
+++ a/MAINTAINERS
@@ -4716,6 +4716,7 @@ L:	linux-iio@vger.kernel.org
 S:	Maintained
 F:	drivers/iio/
 F:	drivers/staging/iio/
+F:	include/linux/iio/
 
 IKANOS/ADI EAGLE ADSL USB DRIVER
 M:	Matthieu Castet <castet.matthieu@free.fr>
_

Patches currently in -mm which might be from daniel.baluta@intel.com are

linux-next.patch


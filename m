From: akpm@linux-foundation.org
Subject: + maintainers-add-iio-include-files.patch added to -mm tree
Date: Thu, 13 Nov 2014 12:04:09 -0800
Message-ID: <54650eb9.RZUknfyOnIP/3ZfC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMUEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 15:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, cristina.ciocan@intel.com, jg1.han@samsung.com, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add IIO include files
has been added to the -mm tree.  Its filename is
     maintainers-add-iio-include-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-iio-include-files.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-iio-include-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-add-iio-include-files.patch
linux-next.patch


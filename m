From: akpm@linux-foundation.org
Subject: + staging-iio-ring_sw-add-select-of-triggers-to-avoid-build-issue.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:20:37 -0700
Message-ID: <201007302120.o6ULKbDn001006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab0G3VVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:21:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk


The patch titled
     staging:iio:ring_sw: add select of triggers to avoid build issue
has been added to the -mm tree.  Its filename is
     staging-iio-ring_sw-add-select-of-triggers-to-avoid-build-issue.patch

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
Subject: staging:iio:ring_sw: add select of triggers to avoid build issue
From: Jonathan Cameron <jic23@cam.ac.uk>

Currently all drivers that use ring_sw use triggers and I am yet
to see a good reason for any driver not doing so.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/iio/Kconfig~staging-iio-ring_sw-add-select-of-triggers-to-avoid-build-issue drivers/staging/iio/Kconfig
--- a/drivers/staging/iio/Kconfig~staging-iio-ring_sw-add-select-of-triggers-to-avoid-build-issue
+++ a/drivers/staging/iio/Kconfig
@@ -21,6 +21,7 @@ config IIO_RING_BUFFER
 if IIO_RING_BUFFER
 
 config IIO_SW_RING
+       select IIO_TRIGGER
 	tristate "Industrial I/O lock free software ring"
 	help
 	  Example software ring buffer implementation.  The design aim
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

linux-next.patch
staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds.patch
staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case.patch
staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case.patch
staging-iio-ring_sw-add-select-of-triggers-to-avoid-build-issue.patch
staging-iio-ring_sw-remove-unnecessary-function-stub.patch
staging-iio-ring_sw-fix-pointer-arithmetic-for-64bit-arches-by-using-phys_addr_t.patch
misc-rohm-bh1780gli-ambient-light-sensor-driver.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch
add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch
bmp085-add-interface-documentation-and-link-to-datasheet.patch
hmc6352-add-driver-for-the-hmc6352-compass.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch


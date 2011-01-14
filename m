From: akpm@linux-foundation.org
Subject: [merged] include-gpioh-remove-remaining-__must_check-annotiations.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:54 -0800
Message-ID: <201101142252.p0EMqiC0005650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775Ab1ANWw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     include/gpio.h: remove remaining __must_check-annotiations
has been removed from the -mm tree.  Its filename was
     include-gpioh-remove-remaining-__must_check-annotiations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/gpio.h: remove remaining __must_check-annotiations
From: Wolfram Sang <w.sang@pengutronix.de>

5f829e405 ("gpiolib: add missing functions to generic fallback") also
introduced two.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gpio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gpio.h~include-gpioh-remove-remaining-__must_check-annotiations include/linux/gpio.h
--- a/include/linux/gpio.h~include-gpioh-remove-remaining-__must_check-annotiations
+++ a/include/linux/gpio.h
@@ -35,13 +35,13 @@ static inline int gpio_request(unsigned 
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_one(unsigned gpio,
+static inline int gpio_request_one(unsigned gpio,
 					unsigned long flags, const char *label)
 {
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_array(struct gpio *array, size_t num)
+static inline int gpio_request_array(struct gpio *array, size_t num)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch


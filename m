From: akpm@linux-foundation.org
Subject: + sfc-remove-sub-minor-component-from-driver-version.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:47 -0700
Message-ID: <200805200327.m4K3Rl2l002724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbYETD1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: remove sub-minor component from driver version
has been added to the -mm tree.  Its filename is
     sfc-remove-sub-minor-component-from-driver-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: remove sub-minor component from driver version
From: Ben Hutchings <bhutchings@solarflare.com>

This driver has diverged from the out-of-tree driver to which the version
number originally applied.  It should be identified primarily by kernel
version.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/net_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sfc/net_driver.h~sfc-remove-sub-minor-component-from-driver-version drivers/net/sfc/net_driver.h
--- a/drivers/net/sfc/net_driver.h~sfc-remove-sub-minor-component-from-driver-version
+++ a/drivers/net/sfc/net_driver.h
@@ -42,7 +42,7 @@
 #ifndef EFX_DRIVER_NAME
 #define EFX_DRIVER_NAME	"sfc"
 #endif
-#define EFX_DRIVER_VERSION	"2.2.0136"
+#define EFX_DRIVER_VERSION	"2.2"
 
 #ifdef EFX_ENABLE_DEBUG
 #define EFX_BUG_ON_PARANOID(x) BUG_ON(x)
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch
sfc-remove-casts-to-void.patch
sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch
sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch
sfc-add-and-remove-braces-to-comply-with-kernel-style.patch
sfc-replace-various-macros-with-inline-functions.patch
sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch
sfc-use-resource_size_t-for-pci-bus-address.patch
sfc-correct-and-expand-some-comments.patch
sfc-do-not-define-inline-macro.patch
sfc-remove-redundant-casts-to-and-from-void.patch
sfc-add-checks-for-heap-allocation-failure.patch
sfc-remove-sub-minor-component-from-driver-version.patch


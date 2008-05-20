From: akpm@linux-foundation.org
Subject: + sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:32 -0700
Message-ID: <200805200327.m4K3RWD5002695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253AbYETD1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: remove unncesssary UL suffixes on 0 literals
has been added to the -mm tree.  Its filename is
     sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch

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
Subject: sfc: remove unncesssary UL suffixes on 0 literals
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-remove-unncesssary-ul-suffixes-on-0-literals drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-remove-unncesssary-ul-suffixes-on-0-literals
+++ a/drivers/net/sfc/efx.c
@@ -793,7 +793,7 @@ static int efx_init_io(struct efx_nic *e
  fail4:
 	release_mem_region(efx->membase_phys, efx->type->mem_map_size);
  fail3:
-	efx->membase_phys = 0UL;
+	efx->membase_phys = 0;
  fail2:
 	pci_disable_device(efx->pci_dev);
  fail1:
@@ -811,7 +811,7 @@ static void efx_fini_io(struct efx_nic *
 
 	if (efx->membase_phys) {
 		pci_release_region(efx->pci_dev, efx->type->mem_bar);
-		efx->membase_phys = 0UL;
+		efx->membase_phys = 0;
 	}
 
 	pci_disable_device(efx->pci_dev);
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


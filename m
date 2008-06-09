From: akpm@linux-foundation.org
Subject: - pnpacpi-fix-irq-flag-decoding-comment-fix.patch removed from -mm tree
Date: Mon, 09 Jun 2008 16:51:13 -0700
Message-ID: <200806092351.m59NpDnG015734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbYFIXxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 19:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, ThJaeger@gmail.com, bjorn.helgaas@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pnpacpi-fix-irq-flag-decoding comment fix
has been removed from the -mm tree.  Its filename was
     pnpacpi-fix-irq-flag-decoding-comment-fix.patch

This patch was dropped because it was folded into pnpacpi-fix-irq-flag-decoding.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi-fix-irq-flag-decoding comment fix
From: Rene Herman <rene.herman@keyaccess.nl>

This would also imply the attached is a comment fix...

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Tom Jaeger <ThJaeger@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/ioport.h~pnpacpi-fix-irq-flag-decoding-comment-fix include/linux/ioport.h
--- a/include/linux/ioport.h~pnpacpi-fix-irq-flag-decoding-comment-fix
+++ a/include/linux/ioport.h
@@ -53,14 +53,14 @@ struct resource_list {
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
 
-/* ISA PnP IRQ specific bits (IORESOURCE_BITS) */
+/* PnP IRQ specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IRQ_HIGHEDGE		(1<<0)
 #define IORESOURCE_IRQ_LOWEDGE		(1<<1)
 #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
 #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
 #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
 
-/* ISA PnP DMA specific bits (IORESOURCE_BITS) */
+/* PnP DMA specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
 #define IORESOURCE_DMA_8BIT		(0<<0)
 #define IORESOURCE_DMA_8AND16BIT	(1<<0)
@@ -76,7 +76,7 @@ struct resource_list {
 #define IORESOURCE_DMA_TYPEB		(2<<6)
 #define IORESOURCE_DMA_TYPEF		(3<<6)
 
-/* ISA PnP memory I/O specific bits (IORESOURCE_BITS) */
+/* PnP memory I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_MEM_WRITEABLE	(1<<0)	/* dup: IORESOURCE_READONLY */
 #define IORESOURCE_MEM_CACHEABLE	(1<<1)	/* dup: IORESOURCE_CACHEABLE */
 #define IORESOURCE_MEM_RANGELENGTH	(1<<2)	/* dup: IORESOURCE_RANGELENGTH */
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch
pnp-make-resource-option-structures-private-to-pnp-subsystem.patch
pnp-support-optional-irq-resources.patch
pnp-remove-extra-0x100-bit-from-option-priority.patch
isapnp-handle-independent-options-following-dependent-ones.patch
pnp-convert-resource-options-to-single-linked-list.patch


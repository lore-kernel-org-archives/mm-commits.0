Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F0EC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BFA2224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709106;
	bh=MSe5Wv1QVACVgLo9K/l1WlFufyBo4HdflMsWvF7LSss=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=T5PROwJVClz46hbi6bSh9ytqG3e2I+TE0/Ijhi3kwMuwUONmOTQ3DzwQwSEXYUSkA
	 wtw5SZzZBI3t8+W+uRQcETcwWOtm5vvThH+Xevc6iP/1bRHXWFQEb3lGV4ewYAMfwZ
	 7eSVNWE+vL5mbEuLoMIQuQEuVoa2nsa8c7f27zc0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgJNU60 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNU6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92E220725;
        Wed, 14 Oct 2020 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709104;
        bh=MSe5Wv1QVACVgLo9K/l1WlFufyBo4HdflMsWvF7LSss=;
        h=Date:From:To:Subject:From;
        b=akW2pxK4jPqdy1zMTkPU8fUC25utDKlMyae4+NqAIa+qddKAq386Zv4v7RRI7/VSk
         Y7gglqoU7SplWbcly+U0vpoOrNSK2SkgW383PHuCVcb2f2cA1bS1R2aMg0LE35bXBs
         wuvqnx39gwPZWdF4BTctMcOGAQvgA6A55uv0br+M=
Date:   Wed, 14 Oct 2020 13:58:22 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, lkp@intel.com, luto@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@linux.ibm.com,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [merged]
 device-dax-make-align-a-per-device-property.patch removed from -mm tree
Message-ID: <20201014205822.WdaEWLp9F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make align a per-device property
has been removed from the -mm tree.  Its filename was
     device-dax-make-align-a-per-device-property.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: make align a per-device property

Introduce @align to struct dev_dax.

When creating a new device, we still initialize to the default dax_region
@align.  Child devices belonging to a region may wish to keep a different
alignment property instead of a global region-defined one.

Link: https://lkml.kernel.org/r/159643105377.4062302.4159447829955683131.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-2-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106117957.30709.1142303024324655705.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |    1=20
 drivers/dax/dax-private.h |    3 ++
 drivers/dax/device.c      |   41 +++++++++++++-----------------------
 3 files changed, 19 insertions(+), 26 deletions(-)

--- a/drivers/dax/bus.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/bus.c
@@ -1218,6 +1218,7 @@ struct dev_dax *devm_create_dev_dax(stru
=20
 	dev_dax->dax_dev =3D dax_dev;
 	dev_dax->target_node =3D dax_region->target_node;
+	dev_dax->align =3D dax_region->align;
 	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
=20
--- a/drivers/dax/dax-private.h~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/dax-private.h
@@ -62,6 +62,7 @@ struct dax_mapping {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	unsigned int align;
 	int target_node;
 	int id;
 	struct ida ida;
@@ -84,4 +85,6 @@ static inline struct dax_mapping *to_dax
 {
 	return container_of(dev, struct dax_mapping, dev);
 }
+
+phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsi=
gned long size);
 #endif
--- a/drivers/dax/device.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/device.c
@@ -17,7 +17,6 @@
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
-	struct dax_region *dax_region =3D dev_dax->region;
 	struct device *dev =3D &dev_dax->dev;
 	unsigned long mask;
=20
@@ -32,7 +31,7 @@ static int check_vma(struct dev_dax *dev
 		return -EINVAL;
 	}
=20
-	mask =3D dax_region->align - 1;
+	mask =3D dev_dax->align - 1;
 	if (vma->vm_start & mask || vma->vm_end & mask) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
@@ -78,21 +77,19 @@ static vm_fault_t __dev_dax_pte_fault(st
 				struct vm_fault *vmf, pfn_t *pfn)
 {
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	unsigned int fault_size =3D PAGE_SIZE;
=20
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PAGE_SIZE) {
+	if (dev_dax->align > PAGE_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size !=3D dax_region->align)
+	if (fault_size !=3D dev_dax->align)
 		return VM_FAULT_SIGBUS;
=20
 	phys =3D dax_pgoff_to_phys(dev_dax, vmf->pgoff, PAGE_SIZE);
@@ -111,7 +108,6 @@ static vm_fault_t __dev_dax_pmd_fault(st
 {
 	unsigned long pmd_addr =3D vmf->address & PMD_MASK;
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size =3D PMD_SIZE;
@@ -119,16 +115,15 @@ static vm_fault_t __dev_dax_pmd_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PMD_SIZE) {
+	if (dev_dax->align > PMD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
=20
 	/* if we are outside of the VMA */
@@ -154,7 +149,6 @@ static vm_fault_t __dev_dax_pud_fault(st
 {
 	unsigned long pud_addr =3D vmf->address & PUD_MASK;
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size =3D PUD_SIZE;
@@ -163,16 +157,15 @@ static vm_fault_t __dev_dax_pud_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PUD_SIZE) {
+	if (dev_dax->align > PUD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
=20
 	/* if we are outside of the VMA */
@@ -267,9 +260,8 @@ static int dev_dax_split(struct vm_area_
 {
 	struct file *filp =3D vma->vm_file;
 	struct dev_dax *dev_dax =3D filp->private_data;
-	struct dax_region *dax_region =3D dev_dax->region;
=20
-	if (!IS_ALIGNED(addr, dax_region->align))
+	if (!IS_ALIGNED(addr, dev_dax->align))
 		return -EINVAL;
 	return 0;
 }
@@ -278,9 +270,8 @@ static unsigned long dev_dax_pagesize(st
 {
 	struct file *filp =3D vma->vm_file;
 	struct dev_dax *dev_dax =3D filp->private_data;
-	struct dax_region *dax_region =3D dev_dax->region;
=20
-	return dax_region->align;
+	return dev_dax->align;
 }
=20
 static const struct vm_operations_struct dax_vm_ops =3D {
@@ -319,13 +310,11 @@ static unsigned long dax_get_unmapped_ar
 {
 	unsigned long off, off_end, off_align, len_align, addr_align, align;
 	struct dev_dax *dev_dax =3D filp ? filp->private_data : NULL;
-	struct dax_region *dax_region;
=20
 	if (!dev_dax || addr)
 		goto out;
=20
-	dax_region =3D dev_dax->region;
-	align =3D dax_region->align;
+	align =3D dev_dax->align;
 	off =3D pgoff << PAGE_SHIFT;
 	off_end =3D off + len;
 	off_align =3D round_up(off, align);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are



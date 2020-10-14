Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CE5C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 469CC22258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709087;
	bh=veuCM4iLVBdHyzDmHlMhdeAEFkT5wuvckEm2kVipICo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fZRZqk2+slMk2Yi4JS2kffZSI7Wu8Dq7aDClTo45bgJKlSk8n0wpnGkDuYYBzVoqI
	 QAGmWTq+YcCropmn8/gYIzPHmMaZMT0CHR+4MhjaBu7byIMqK+kDfXJUtBz2erHxCN
	 fDgavdWjxqT5hZ1EgqTMFQdv5K0ybft3v+F7HqKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgJNU6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46F292224D;
        Wed, 14 Oct 2020 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709085;
        bh=veuCM4iLVBdHyzDmHlMhdeAEFkT5wuvckEm2kVipICo=;
        h=Date:From:To:Subject:From;
        b=PAUNNtSbanjCdGORHGuwvdBSEQWH+9bUCmAMX55XlvMcK8ikLD+aTj1n/w2qGfBlw
         iMbw23Y2NBw4J7Yf5ylYvq9zDkAy2BuOuJ7T2prL08SSSSYjXDE+Y+XY8h9vqS9KoP
         n6c5MmJxwVlID3NJE2Sfe9RI4NgBWe38rf8fZr/0=
Date:   Wed, 14 Oct 2020 13:58:02 -0700
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
Subject:  [merged] device-dax-add-resize-support.patch removed from
 -mm tree
Message-ID: <20201014205802.CV2AM8thY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add resize support
has been removed from the -mm tree.  Its filename was
     device-dax-add-resize-support.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: add resize support

Make the device-dax 'size' attribute writable to allow capacity to be
split between multiple instances in a region.  The intended consumers of
this capability are users that want to split a scarce memory resource
between device-dax and System-RAM access, or users that want to have
multiple security domains for a large region.

By default the hmem instance provider allocates an entire region to the
first instance.  The process of creating a new instance (assuming a
region-id of 0) is find the region and trigger the 'create' attribute
which yields an empty instance to configure.  For example:

    cd /sys/bus/dax/devices
    echo dax0.0 > dax0.0/driver/unbind
    echo $new_size > dax0.0/size
    echo 1 > $(readlink -f dax0.0)../dax_region/create
    seed=3D$(cat $(readlink -f dax0.0)../dax_region/seed)
    echo $new_size > $seed/size
    echo dax0.0 > ../drivers/{device_dax,kmem}/bind
    echo dax0.1 > ../drivers/{device_dax,kmem}/bind

Instances can be destroyed by:

    echo $device > $(readlink -f $device)../dax_region/delete

Link: https://lkml.kernel.org/r/159643102625.4062302.7431838945566033852.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106115239.30709.9850106928133493138.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
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
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |  161 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 152 insertions(+), 9 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-resize-support
+++ a/drivers/dax/bus.c
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
+#include <linux/io.h>
 #include "dax-private.h"
 #include "bus.h"
=20
@@ -562,7 +563,8 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
=20
-static int alloc_dev_dax_range(struct dev_dax *dev_dax, resource_size_t si=
ze)
+static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
+		resource_size_t size)
 {
 	struct dax_region *dax_region =3D dev_dax->region;
 	struct resource *res =3D &dax_region->res;
@@ -580,12 +582,7 @@ static int alloc_dev_dax_range(struct de
 		return 0;
 	}
=20
-	/* TODO: handle multiple allocations per region */
-	if (res->child)
-		return -ENOMEM;
-
-	alloc =3D __request_region(res, res->start, size, dev_name(dev), 0);
-
+	alloc =3D __request_region(res, start, size, dev_name(dev), 0);
 	if (!alloc)
 		return -ENOMEM;
=20
@@ -597,6 +594,29 @@ static int alloc_dev_dax_range(struct de
 	return 0;
 }
=20
+static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *=
res, resource_size_t size)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+	int rc =3D 0;
+
+	device_lock_assert(dax_region->dev);
+
+	if (size)
+		rc =3D adjust_resource(res, range->start, size);
+	else
+		__release_region(&dax_region->res, range->start, range_len(range));
+	if (rc)
+		return rc;
+
+	dev_dax->range =3D (struct range) {
+		.start =3D range->start,
+		.end =3D range->start + size - 1,
+	};
+
+	return 0;
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -605,7 +625,127 @@ static ssize_t size_show(struct device *
=20
 	return sprintf(buf, "%llu\n", size);
 }
-static DEVICE_ATTR_RO(size);
+
+static bool alloc_is_aligned(struct dax_region *dax_region,
+		resource_size_t size)
+{
+	/*
+	 * The minimum mapping granularity for a device instance is a
+	 * single subsection, unless the arch says otherwise.
+	 */
+	return IS_ALIGNED(size, max_t(unsigned long, dax_region->align,
+				memremap_compat_align()));
+}
+
+static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+	struct resource *res, *adjust =3D NULL;
+	struct device *dev =3D &dev_dax->dev;
+
+	for_each_dax_region_resource(dax_region, res)
+		if (strcmp(res->name, dev_name(dev)) =3D=3D 0
+				&& res->start =3D=3D range->start) {
+			adjust =3D res;
+			break;
+		}
+
+	if (dev_WARN_ONCE(dev, !adjust, "failed to find matching resource\n"))
+		return -ENXIO;
+	return adjust_dev_dax_range(dev_dax, adjust, size);
+}
+
+static ssize_t dev_dax_resize(struct dax_region *dax_region,
+		struct dev_dax *dev_dax, resource_size_t size)
+{
+	resource_size_t avail =3D dax_region_avail_size(dax_region), to_alloc;
+	resource_size_t dev_size =3D range_len(&dev_dax->range);
+	struct resource *region_res =3D &dax_region->res;
+	struct device *dev =3D &dev_dax->dev;
+	const char *name =3D dev_name(dev);
+	struct resource *res, *first;
+
+	if (dev->driver)
+		return -EBUSY;
+	if (size =3D=3D dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+	if (size < dev_size)
+		return dev_dax_shrink(dev_dax, size);
+
+	to_alloc =3D size - dev_size;
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dax_region, to_alloc),
+			"resize of %pa misaligned\n", &to_alloc))
+		return -ENXIO;
+
+	/*
+	 * Expand the device into the unused portion of the region. This
+	 * may involve adjusting the end of an existing resource, or
+	 * allocating a new resource.
+	 */
+	first =3D region_res->child;
+	if (!first)
+		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+	for (res =3D first; to_alloc && res; res =3D res->sibling) {
+		struct resource *next =3D res->sibling;
+		resource_size_t free;
+
+		/* space at the beginning of the region */
+		free =3D 0;
+		if (res =3D=3D first && res->start > dax_region->res.start)
+			free =3D res->start - dax_region->res.start;
+		if (free >=3D to_alloc && dev_size =3D=3D 0)
+			return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+
+		free =3D 0;
+		/* space between allocations */
+		if (next && next->start > res->end + 1)
+			free =3D next->start - res->end + 1;
+
+		/* space at the end of the region */
+		if (free < to_alloc && !next && res->end < region_res->end)
+			free =3D region_res->end - res->end;
+
+		if (free >=3D to_alloc && strcmp(name, res->name) =3D=3D 0)
+			return adjust_dev_dax_range(dev_dax, res, resource_size(res) + to_alloc=
);
+		else if (free >=3D to_alloc && dev_size =3D=3D 0)
+			return alloc_dev_dax_range(dev_dax, res->end + 1, to_alloc);
+	}
+	return -ENOSPC;
+}
+
+static ssize_t size_store(struct device *dev, struct device_attribute *att=
r,
+		const char *buf, size_t len)
+{
+	ssize_t rc;
+	unsigned long long val;
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	rc =3D kstrtoull(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (!alloc_is_aligned(dax_region, val)) {
+		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
+		return -EINVAL;
+	}
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+	device_lock(dev);
+	rc =3D dev_dax_resize(dax_region, dev_dax, val);
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+
+	return rc =3D=3D 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(size);
=20
 static int dev_dax_target_node(struct dev_dax *dev_dax)
 {
@@ -654,11 +794,14 @@ static umode_t dev_dax_visible(struct ko
 {
 	struct device *dev =3D container_of(kobj, struct device, kobj);
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
=20
 	if (a =3D=3D &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) <=
 0)
 		return 0;
 	if (a =3D=3D &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
+	if (a =3D=3D &dev_attr_size.attr && is_static(dax_region))
+		return 0444;
 	return a->mode;
 }
=20
@@ -739,7 +882,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
=20
-	rc =3D alloc_dev_dax_range(dev_dax, data->size);
+	rc =3D alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
 	if (rc)
 		goto err_range;
=20
_

Patches currently in -mm which might be from dan.j.williams@intel.com are



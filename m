Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849CDC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF2E2224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709104;
	bh=5iPqmHxB4Iu0T2nOBKUbei2wpyXizZHGplSZ142HUeM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c4JZv/GHoRGOF4MGKD5fprPtaaKklhv4IGcRYCx0PoHFDTUofeBvzJogSbd/ryThU
	 pwXuWpdGTBkA1HW92QTZOl88+qKXk119IycYsvG8XtyUlTPVac3P+aiXE6DZQ45vBg
	 S2DZbHslGevkAGyNfMd8SfsAUsDyOpOmTQUEbD+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgJNU6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbgJNU6X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF82122253;
        Wed, 14 Oct 2020 20:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709100;
        bh=5iPqmHxB4Iu0T2nOBKUbei2wpyXizZHGplSZ142HUeM=;
        h=Date:From:To:Subject:From;
        b=aU7EsGEhWO+d8RWsLq4XlRXZl3kzUxU92egvAkiQq2HL4Lp9o0nDA/HUzIqVXHtgf
         6XujXI6TU639LqFVgX1T6zS0pOaNrgki0qfCfp0oGyihGKxy3lUe0FH/I1R9ZlgguQ
         nrWj/hamG/5YaaYdO/PgmqVPlFUH3oHfRSTUmb88=
Date:   Wed, 14 Oct 2020 13:58:18 -0700
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
Subject:  [merged] device-dax-introduce-mapping-devices.patch
 removed from -mm tree
Message-ID: <20201014205818.5EOMwAFZX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: introduce 'mapping' devices
has been removed from the -mm tree.  Its filename was
     device-dax-introduce-mapping-devices.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: introduce 'mapping' devices

In support of interrogating the physical address layout of a device with
dis-contiguous ranges, introduce a sysfs directory with 'start', 'end',
and 'page_offset' attributes.  The alternative is trying to parse
/proc/iomem, and that file will not reflect the extent layout until the
device is enabled.

Link: https://lkml.kernel.org/r/159643104819.4062302.13691281391423291589.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106117446.30709.2751020815463722537.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
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

 drivers/dax/bus.c         |  191 +++++++++++++++++++++++++++++++++++-
 drivers/dax/dax-private.h |   14 ++
 2 files changed, 203 insertions(+), 2 deletions(-)

--- a/drivers/dax/bus.c~device-dax-introduce-mapping-devices
+++ a/drivers/dax/bus.c
@@ -579,6 +579,167 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
=20
+static void dax_mapping_release(struct device *dev)
+{
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+
+	ida_free(&dev_dax->ida, mapping->id);
+	kfree(mapping);
+}
+
+static void unregister_dax_mapping(void *data)
+{
+	struct device *dev =3D data;
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	device_lock_assert(dax_region->dev);
+
+	dev_dax->ranges[mapping->range_id].mapping =3D NULL;
+	mapping->range_id =3D -1;
+
+	device_del(dev);
+	put_device(dev);
+}
+
+static struct dev_dax_range *get_dax_range(struct device *dev)
+{
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	device_lock(dax_region->dev);
+	if (mapping->range_id < 0) {
+		device_unlock(dax_region->dev);
+		return NULL;
+	}
+
+	return &dev_dax->ranges[mapping->range_id];
+}
+
+static void put_dax_range(struct dev_dax_range *dax_range)
+{
+	struct dax_mapping *mapping =3D dax_range->mapping;
+	struct dev_dax *dev_dax =3D to_dev_dax(mapping->dev.parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	device_unlock(dax_region->dev);
+}
+
+static ssize_t start_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#llx\n", dax_range->range.start);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(start, 0400, start_show, NULL);
+
+static ssize_t end_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#llx\n", dax_range->range.end);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(end, 0400, end_show, NULL);
+
+static ssize_t pgoff_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#lx\n", dax_range->pgoff);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(page_offset, 0400, pgoff_show, NULL);
+
+static struct attribute *dax_mapping_attributes[] =3D {
+	&dev_attr_start.attr,
+	&dev_attr_end.attr,
+	&dev_attr_page_offset.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_mapping_attribute_group =3D {
+	.attrs =3D dax_mapping_attributes,
+};
+
+static const struct attribute_group *dax_mapping_attribute_groups[] =3D {
+	&dax_mapping_attribute_group,
+	NULL,
+};
+
+static struct device_type dax_mapping_type =3D {
+	.release =3D dax_mapping_release,
+	.groups =3D dax_mapping_attribute_groups,
+};
+
+static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct dax_mapping *mapping;
+	struct device *dev;
+	int rc;
+
+	device_lock_assert(dax_region->dev);
+
+	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
+				"region disabled\n"))
+		return -ENXIO;
+
+	mapping =3D kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping)
+		return -ENOMEM;
+	mapping->range_id =3D range_id;
+	mapping->id =3D ida_alloc(&dev_dax->ida, GFP_KERNEL);
+	if (mapping->id < 0) {
+		kfree(mapping);
+		return -ENOMEM;
+	}
+	dev_dax->ranges[range_id].mapping =3D mapping;
+	dev =3D &mapping->dev;
+	device_initialize(dev);
+	dev->parent =3D &dev_dax->dev;
+	dev->type =3D &dax_mapping_type;
+	dev_set_name(dev, "mapping%d", mapping->id);
+	rc =3D device_add(dev);
+	if (rc) {
+		put_device(dev);
+		return rc;
+	}
+
+	rc =3D devm_add_action_or_reset(dax_region->dev, unregister_dax_mapping,
+			dev);
+	if (rc)
+		return rc;
+	return 0;
+}
+
 static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		resource_size_t size)
 {
@@ -588,7 +749,7 @@ static int alloc_dev_dax_range(struct de
 	struct dev_dax_range *ranges;
 	unsigned long pgoff =3D 0;
 	struct resource *alloc;
-	int i;
+	int i, rc;
=20
 	device_lock_assert(dax_region->dev);
=20
@@ -633,6 +794,22 @@ static int alloc_dev_dax_range(struct de
=20
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
 			&alloc->start, &alloc->end);
+	/*
+	 * A dev_dax instance must be registered before mapping device
+	 * children can be added. Defer to devm_create_dev_dax() to add
+	 * the initial mapping device.
+	 */
+	if (!device_is_registered(&dev_dax->dev))
+		return 0;
+
+	rc =3D devm_register_dax_mapping(dev_dax, dev_dax->nr_range - 1);
+	if (rc) {
+		dev_dbg(dev, "delete range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
+				&alloc->start, &alloc->end);
+		dev_dax->nr_range--;
+		__release_region(res, alloc->start, resource_size(alloc));
+		return rc;
+	}
=20
 	return 0;
 }
@@ -701,11 +878,14 @@ static int dev_dax_shrink(struct dev_dax
=20
 	for (i =3D dev_dax->nr_range - 1; i >=3D 0; i--) {
 		struct range *range =3D &dev_dax->ranges[i].range;
+		struct dax_mapping *mapping =3D dev_dax->ranges[i].mapping;
 		struct resource *adjust =3D NULL, *res;
 		resource_size_t shrink;
=20
 		shrink =3D min_t(u64, to_shrink, range_len(range));
 		if (shrink >=3D range_len(range)) {
+			devm_release_action(dax_region->dev,
+					unregister_dax_mapping, &mapping->dev);
 			__release_region(&dax_region->res, range->start,
 					range_len(range));
 			dev_dax->nr_range--;
@@ -1036,9 +1216,9 @@ struct dev_dax *devm_create_dev_dax(stru
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
=20
-	/* from here on we're committed to teardown via dev_dax_release() */
 	dev_dax->dax_dev =3D dax_dev;
 	dev_dax->target_node =3D dax_region->target_node;
+	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
=20
 	inode =3D dax_inode(dax_dev);
@@ -1061,6 +1241,13 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (rc)
 		return ERR_PTR(rc);
=20
+	/* register mapping device for the initial allocation range */
+	if (dev_dax->nr_range && range_len(&dev_dax->ranges[0].range)) {
+		rc =3D devm_register_dax_mapping(dev_dax, 0);
+		if (rc)
+			return ERR_PTR(rc);
+	}
+
 	return dev_dax;
=20
 err_alloc_dax:
--- a/drivers/dax/dax-private.h~device-dax-introduce-mapping-devices
+++ a/drivers/dax/dax-private.h
@@ -40,6 +40,12 @@ struct dax_region {
 	struct device *youngest;
 };
=20
+struct dax_mapping {
+	struct device dev;
+	int range_id;
+	int id;
+};
+
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
@@ -47,6 +53,7 @@ struct dax_region {
  * @dax_dev - core dax functionality
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @id: ida allocated id
+ * @ida: mapping id allocator
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @nr_range: size of @ranges
@@ -57,12 +64,14 @@ struct dev_dax {
 	struct dax_device *dax_dev;
 	int target_node;
 	int id;
+	struct ida ida;
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	int nr_range;
 	struct dev_dax_range {
 		unsigned long pgoff;
 		struct range range;
+		struct dax_mapping *mapping;
 	} *ranges;
 };
=20
@@ -70,4 +79,9 @@ static inline struct dev_dax *to_dev_dax
 {
 	return container_of(dev, struct dev_dax, dev);
 }
+
+static inline struct dax_mapping *to_dax_mapping(struct device *dev)
+{
+	return container_of(dev, struct dax_mapping, dev);
+}
 #endif
_

Patches currently in -mm which might be from dan.j.williams@intel.com are



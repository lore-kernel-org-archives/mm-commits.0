Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668695;
	b=AaQdAEsSRpKglAqpddPj3eVBirL6zXDnUvPnK4rSRwDD7u2Lv2ywbpDt+WJzpf5Jui99
	 mMtm/ipPeRQsJYIE+opf6hYOvJYnDQ9qqr5jIvkI1Br0mrSYpl+jpqoUxVzdWeRnOyz6b
	 zgPZZLKF+bmIiwBmy5XyW1MhBJ/PIq39e1b4Xkbx45OQ/WWVqoMHEnIsFZwCx5oLEL0di
	 pSz5kGbJl+NJIaJnc7IKstHA+6Hg2+acMQi/thca2z2Rc4Zzw83x0VcqfHMeqSiPbtVlX
	 l8CryYsz5F2ygjvZmkL0JVDp3VGhs3lg/SJUyJgIJ/hs94C7sbjgE0kv2cUU3HvN+JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668695;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=U/IZCLJeWK+vCcvF92qefZEVrtbzR4SOe7ttZTFmIR0=;
	b=wy2kfJAf5fOoz+FHYKqJKAt8LQCZ1t/hg+TIcuHzXmjY+AJ4q6WiBVj/4MlsZfOhWwVR
	 Qrp0Mt8WqVxt3+2ljZWO4rMkFiDMIhmDCHq2CHtW02BFGRgiPtxQHrd2hGFx8IjsGw8iE
	 ZWf7gA2eGS59zITa724LJOLDiU/Xi35cLP3O9efhlcOGFXzgG4btF/tClnU2L2fgG4l1s
	 mOONkQkdMLoqNlA6Nq17hoPUAYWJjM60Sqhmr0F5If60FZo+jwzSc/TmjKC8nBY0nv2mY
	 d2IvQSmyaplYCJQV9Ptq93H4g/EcLEEiVzDuc+76D6ix0hZT/wH0zxANwwIUTSicumw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hcT0sfrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556E606A332
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hcT0sfrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC461F000C1;
	Tue,  3 Nov 2026 01:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668695;
	bh=U/IZCLJeWK+vCcvF92qefZEVrtbzR4SOe7ttZTFmIR0=;
	h=Date:To:From:Subject;
	b=hcT0sfrbV+Bp0ZdNsExa5olr8a+U/+ZaQq3XDJW4fEZ4bw+7QuT/NOgeiym6h/Gyq
	 cAcZd5d1ZfvbjJASWlythGVA7wo506GV0GnQFb0bQFa/QRDDEuTzfup4FfuLBCng/M
	 +wLLDN7LXGM3UH7jB7hRLkAhLzJR3B8epYNRK5vA=
Date: Mon, 02 Nov 2026 17:18:14 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-grammar-and-typos.patch added to mm-new branch
Message-Id: <20261103011814.DDC461F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: fix grammar and typos
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-fix-grammar-and-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-grammar-and-typos.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aveline Noir <jm5905938@gmail.com>
Subject: Docs/mm/damon/design: fix grammar and typos
Date: Mon, 02 Nov 2026 16:59:35 -0800

The design doc has quite a few relative clauses that seem to have lost
their verb, like "pages that assumed to have" or "filters that handled
by the core layer".  Fix those, along with some agreement issues and a
couple of typos: "Parreto", and "Use space", which I think should be
"User space".  Rewrap where the lines got too long.

Link: https://lore.kernel.org/20261103005940.91432-6-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
---

 Documentation/mm/damon/design.rst |  108 ++++++++++++++--------------
 1 file changed, 54 insertions(+), 54 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-grammar-and-typos
+++ a/Documentation/mm/damon/design.rst
@@ -33,13 +33,13 @@ Overall Architecture
 DAMON subsystem is configured with three layers including
 
 - :ref:`Operations Set <damon_operations_set>`: Implements fundamental
-  operations for DAMON that depends on the given monitoring target
+  operations for DAMON that depend on the given monitoring target
   address-space and available set of software/hardware primitives,
 - :ref:`Core <damon_core_logic>`: Implements core logics including monitoring
   overhead/accuracy control and access-aware system operations on top of the
   operations set layer, and
 - :ref:`Modules <damon_modules>`: Implements kernel modules for various
-  purposes that provides interfaces for the user space, on top of the core
+  purposes that provide interfaces for the user space, on top of the core
   layer.
 
 
@@ -134,8 +134,8 @@ finding the relevant PTE Accessed bit(s)
 implementation for the virtual address walks the page table for the target task
 of the address, the implementation for the physical address walks every page
 table having a mapping to the address.  In this way, the implementations find
-and clear the bit(s) for next sampling target address and checks whether the
-bit(s) set again after one sampling period.  This could disturb other kernel
+and clear the bit(s) for next sampling target address and check whether the
+bit(s) are set again after one sampling period.  This could disturb other kernel
 subsystems using the Accessed bits, namely Idle page tracking and the reclaim
 logic.  DAMON does nothing to avoid disturbing Idle page tracking, so handling
 the interference is the responsibility of sysadmins.  However, it solves the
@@ -152,7 +152,7 @@ ranges.  In some cases, the address spac
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
 parameter called ``address unit`` is provided.  It represents the scale factor
-that need to be multiplied to the core layer's address for calculating real
+that needs to be multiplied to the core layer's address for calculating real
 address on the given address space.  Support of ``address unit`` parameter is
 up to each operations set implementation.  ``paddr`` is the only operations set
 implementation that supports the parameter.
@@ -194,9 +194,9 @@ duration.  The resolution of the access
 ``sampling interval`` and ``aggregation interval``.  In detail, DAMON checks
 access to each page per ``sampling interval`` and aggregates the results.  In
 other words, counts the number of the accesses to each page.  After each
-``aggregation interval`` passes, DAMON calls callback functions that previously
-registered by users so that users can read the aggregated results and then
-clears the results.  This can be described in below simple pseudo-code::
+``aggregation interval`` passes, DAMON calls callback functions that were
+previously registered by users so that users can read the aggregated results and
+then clears the results.  This can be described in below simple pseudo-code::
 
     while monitoring_on:
         for page in monitoring_target:
@@ -219,11 +219,11 @@ Region Based Sampling
 ~~~~~~~~~~~~~~~~~~~~~
 
 To avoid the unbounded increase of the overhead, DAMON groups adjacent pages
-that assumed to have the same access frequencies into a region.  As long as the
-assumption (pages in a region have the same access frequencies) is kept, only
-one page in the region is required to be checked.  Thus, for each ``sampling
-interval``, DAMON randomly picks one page in each region, waits for one
-``sampling interval``, checks whether the page is accessed meanwhile, and
+that are assumed to have the same access frequencies into a region.  As long as
+the assumption (pages in a region have the same access frequencies) is kept,
+only one page in the region is required to be checked.  Thus, for each
+``sampling interval``, DAMON randomly picks one page in each region, waits for
+one ``sampling interval``, checks whether the page is accessed meanwhile, and
 increases the access frequency counter of the region if so.  The counter is
 called ``nr_accesses`` of the region.  Therefore, the monitoring overhead is
 controllable by setting the number of regions.  DAMON allows users to set the
@@ -289,7 +289,7 @@ attributes monitoring feature is provide
 
 Using the feature, users can register data attributes of their interest to the
 DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
-registration is made by specifying a probe per attribute.  Each of the probe
+registration is made by specifying a probe per attribute.  Each of the probes
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
@@ -305,12 +305,12 @@ filter types.  Currently below filter ty
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-<damon_design_region_based_sampling>`.  The number of samples that identified
-as having the data attribute (hitting the probe) per :ref:`aggregation interval
-<damon_design_monitoring>` is accounted in a per-region per-probe counter.
-Users can therefore know how much of a given DAMON region has a specific data
-attribute by reading the per-region per-probe probe hits counter after each
-aggregation interval.
+<damon_design_region_based_sampling>`.  The number of samples that are
+identified as having the data attribute (hitting the probe) per
+:ref:`aggregation interval <damon_design_monitoring>` is accounted in a
+per-region per-probe counter.  Users can therefore know how much of a given
+DAMON region has a specific data attribute by reading the per-region per-probe
+probe hits counter after each aggregation interval.
 
 Users can optionally register probing preparation actions per probe.  If such
 actions are registered, DAMON applies the actions to each region's sampling
@@ -358,7 +358,7 @@ can use the mode.
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-The monitoring target address range could dynamically changed.  For example,
+The monitoring target address range could be dynamically changed.  For example,
 virtual memory could be dynamically mapped and unmapped.  Physical memory could
 be hot-plugged.
 
@@ -396,8 +396,8 @@ to converge regions with the :ref:`regio
 time scale of the given purpose.  This could happen if the workload is actually
 making only rare accesses but the user thinks the amount of accesses for the
 monitoring purpose too high.  For such cases, the target amount of access to
-capture per ``aggregation interval`` should carefully reconsidered.  Also, note
-that the captured amount of accesses is represented with not only
+capture per ``aggregation interval`` should be carefully reconsidered.  Also,
+note that the captured amount of accesses is represented with not only
 ``nr_accesses``, but also ``age``.  For example, even if every region on the
 monitoring results show zero ``nr_accesses``, regions could still be
 distinguished using ``age`` values as the recency information.
@@ -444,7 +444,7 @@ interval`` based on the :ref:`the tuning
 users to set the aimed amount of access events to observe via DAMON within
 given time interval.  The target can be specified by the user as a ratio of
 DAMON-observed access events to the theoretical maximum amount of the events
-(``access_bp``) that measured within a given number of aggregations
+(``access_bp``) that is measured within a given number of aggregations
 (``aggrs``).  The ratio is in basis point (bp or 1/10,000).
 
 The DAMON-observed access events are calculated in byte granularity based on
@@ -456,7 +456,7 @@ with theoretical maximum ``nr_accesses``
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampling interval`` and ``aggregation
+and increases or decreases the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -465,12 +465,12 @@ The user can further set the minimum and
 be set by the tuning mechanism using two parameters (``min_sample_us`` and
 ``max_sample_us``).  Because the tuning mechanism changes ``sampling interval``
 and ``aggregation interval`` in same ratio always, the minimum and maximum
-``aggregation interval`` after each of the tuning changes can automatically set
-together.
+``aggregation interval`` after each of the tuning changes can be automatically
+set together.
 
-The tuning is turned off by default, and need to be set explicitly by the user.
-As a rule of thumbs and the Parreto principle, 4% access samples ratio target
-is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
+The tuning is turned off by default, and needs to be set explicitly by the user.
+As a rule of thumb and the Pareto principle, 4% access samples ratio target
+is recommended.  Note that Pareto principle (80/20 rule) has been applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
 to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
@@ -708,14 +708,14 @@ auto-tuning mechanism tries to make ``cu
 ``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
-  has interest in for the value.  Use space main workload's latency or
+  have interest in for the value.  User space main workload's latency or
   throughput, system metrics like free memory ratio or memory pressure stall
   time (PSI) could be examples.  Note that users should explicitly set
   ``current_value`` on their own in this case.  In other words, users should
   repeatedly provide the feedback.
 - ``some_mem_psi_us``: System-wide ``some`` memory pressure stall information
-  in microseconds that measured from last quota reset to next quota reset.
-  DAMOS does the measurement on its own, so only ``target_value`` need to be
+  in microseconds that is measured from last quota reset to next quota reset.
+  DAMOS does the measurement on its own, so only ``target_value`` needs to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
 - ``node_mem_used_bp``: Specific NUMA node's used memory ratio in basis point
   (bp or 1/10,000).
@@ -804,16 +804,16 @@ number of filters for each scheme.  Each
 For efficient handling of filters, some types of filters are handled by the
 core layer, while others are handled by operations set.  In the latter case,
 hence, support of the filter types depends on the DAMON operations set.  In
-case of the core layer-handled filters, the memory regions that excluded by the
-filter are not counted as the scheme has tried to the region.  In contrast, if
-a memory regions is filtered by an operations set layer-handled filter, it is
+case of the core layer-handled filters, the memory regions that are excluded by
+the filter are not counted as the scheme has tried to the region.  In contrast,
+if a memory region is filtered by an operations set layer-handled filter, it is
 counted as the scheme has tried.  This difference affects the statistics.
 
-When multiple filters are installed, the group of filters that handled by the
-core layer are evaluated first.  After that, the group of filters that handled
-by the operations layer are evaluated.  Filters in each of the groups are
+When multiple filters are installed, the group of filters that are handled by
+the core layer is evaluated first.  After that, the group of filters that are
+handled by the operations layer is evaluated.  Filters in each of the groups are
 evaluated in the installed order.  If a part of memory is matched to one of the
-filter, next filters are ignored.  If the part passes through the filters
+filters, next filters are ignored.  If the part passes through the filters
 evaluation stage because it is not matched to any of the filters, applying the
 scheme's action to it depends on the last filter's allowance type.  If the last
 filter was for allowing, the part of memory will be rejected, and vice versa.
@@ -832,26 +832,26 @@ Below ``type`` of filters are currently
 
 - Core layer handled
     - addr
-        - Applied to pages that belonging to a given address range.
+        - Applied to pages that belong to a given address range.
     - target
-        - Applied to pages that belonging to a given DAMON monitoring target.
+        - Applied to pages that belong to a given DAMON monitoring target.
     - probe_hits_wsum
         - Matches to monitoring regions having a given range of :ref:`probe
           hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
-        - Applied to pages that containing data that not stored in files.
+        - Applied to pages that contain data that are not stored in files.
     - active
         - Applied to active pages.
     - memcg
-        - Applied to pages that belonging to a given cgroup.
+        - Applied to pages that belong to a given cgroup.
     - young
         - Applied to pages that are accessed after the last access check from the
           scheme.
     - hugepage_size
-        - Applied to pages that managed in a given size range.
+        - Applied to pages that are managed in a given size range.
     - unmapped
-        - Applied to pages that unmapped.
+        - Applied to pages that are unmapped.
 
 To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
@@ -885,14 +885,14 @@ the region is eligible to apply the sche
 <damon_design_damos_access_pattern>`, :ref:`quotas
 <damon_design_damos_quotas>`, :ref:`watermarks
 <damon_design_damos_watermarks>`, and :ref:`filters
-<damon_design_damos_filters>` that handled on core logic could affect this.
+<damon_design_damos_filters>` that are handled on core logic could affect this.
 The core logic will only ask the underlying :ref:`operation set
-<damon_operations_set>` to do apply the action to the region, so whether the
+<damon_operations_set>` to apply the action to the region, so whether the
 action is really applied or not is unclear.  That's why it is called "tried".
 
 "A scheme is applied to a region" means the :ref:`operation set
 <damon_operations_set>` has applied the action to at least a part of the
-region.  The :ref:`filters <damon_design_damos_filters>` that handled by the
+region.  The :ref:`filters <damon_design_damos_filters>` that are handled by the
 operation set, and the types of the :ref:`action <damon_design_damos_action>`
 and the pages of the region can affect this.  For example, if a filter is set
 to exclude anonymous pages and the region has only anonymous pages, or if the
@@ -911,12 +911,12 @@ documentation.
 Regions Walking
 ~~~~~~~~~~~~~~~
 
-DAMOS feature allowing users access each region that a DAMOS action has just
+DAMOS feature allowing users to access each region that a DAMOS action has just
 applied.  Using this feature, DAMON :ref:`API <damon_design_api>` allows users
-access full properties of the regions including the access monitoring results
+to access full properties of the regions including the access monitoring results
 and amount of the region's internal memory that passed the DAMOS filters.
-:ref:`DAMON sysfs interface <sysfs_interface>` also allows users read the data
-via special :ref:`files <sysfs_schemes_tried_regions>`.
+:ref:`DAMON sysfs interface <sysfs_interface>` also allows users to read the
+data via special :ref:`files <sysfs_schemes_tried_regions>`.
 
 .. _damon_design_api:
 
@@ -1001,7 +1001,7 @@ is already running, others will return `
 Sample DAMON Modules
 --------------------
 
-DAMON modules that provides example DAMON kernel API usages.
+DAMON modules that provide example DAMON kernel API usages.
 
 kernel programmers can build their own special or general purpose DAMON modules
 using DAMON kernel API.  To help them easily understand how DAMON kernel API
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch
mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch


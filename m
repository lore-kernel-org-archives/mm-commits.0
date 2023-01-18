Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC76C677F1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjARXxB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjARXws (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEF920062
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE9961A44
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE7C433D2;
        Wed, 18 Jan 2023 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085906;
        bh=tME0p3DdTu2U2rwnyIO7nX0e6L36hPMEzrlqtPFPPjQ=;
        h=Date:To:From:Subject:From;
        b=zWRNNutco2ETnm+XQWcwZ9BphS6CFabF03nTM6wlVzG8iH8IhwN2hjZyQBxklxEIk
         BfZhUXzUET7ZPltHZoDlR1jJnrSNEBx4VNNL3YlZyjuZ2G/gs1JeXHpb+epq2UQ5QS
         GqDcAThx47sPaj9yvud9Z3m87B/Vh/q+mKPSE8LU=
Date:   Wed, 18 Jan 2023 15:51:46 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-deprecate-charge-moving-fix.patch removed from -mm tree
Message-Id: <20230118235146.BBEE7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcontrol-deprecate-charge-moving-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-deprecate-charge-moving-fix.patch

This patch was dropped because it was folded into mm-memcontrol-deprecate-charge-moving.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-deprecate-charge-moving-fix
Date: Sun Dec 18 04:51:34 PM PST 2022

fix memory.rst underlining

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcontrol-deprecate-charge-moving-fix
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -720,7 +720,7 @@ NOTE2:
        otherwise the hard limit will take precedence.
 
 8. Move charges at task migration (DEPRECATED!)
-=================================
+===============================================
 
 THIS IS DEPRECATED!
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch


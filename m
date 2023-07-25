Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32867EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 00:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGYArW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 20:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGYArV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 20:47:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA07C10F8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690246040; x=1721782040;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=1mdciqNFgdlsyPKs6owssUil5RGUyg+3XjHPDbHYXMc=;
  b=eM9AVgE7yZi/dR0fO+ib8t0ZndixiXaOQ05lFoJfRaW6R25iLJ3a6m90
   w2XM8QsqGxHKUjUvnIV9FWrG2o60z1dCbI9IExG971rSP7Q7SdBQhPyCm
   Jn4DWNn8ZqoLnyi2RnOyyHHDvavtPlQ0g/6zOYfP6zrdXcwZGKO7iBZsz
   2e2NEdP4mPFmVhe6VzE2kGPO7UO+dhNwDEu35mZTOomoutx2DfQTm17dr
   47nfym2x/fTxo3Wrdt5FPqcWTUCsMxto7AeD1ggRAtPDwJtIIFhmIsdr4
   NVrUbNNLqLiizm9RhzS6EW62Qm0r8qZ+M+6T/UrPBrF7gpONwutWgNekP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="366473350"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="366473350"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 17:47:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="676021161"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="676021161"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 17:46:48 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Subject: Re: +
 acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
 added to mm-unstable branch
References: <20230724180031.38BFDC433C8@smtp.kernel.org>
Date:   Tue, 25 Jul 2023 08:43:04 +0800
In-Reply-To: <20230724180031.38BFDC433C8@smtp.kernel.org> (Andrew Morton's
        message of "Mon, 24 Jul 2023 11:00:30 -0700")
Message-ID: <87jzuo2547.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> The patch titled
>      Subject: acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
> has been added to the -mm mm-unstable branch.  Its filename is
>      acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
> Date: Mon Jul 24 10:59:52 AM PDT 2023
>
>
> WARNING: Avoid logging continuation uses where feasible
> #54: FILE: drivers/acpi/numa/hmat.c:768:
> +	pr_cont("read_latency: %u, write_latency: %u, read_bandwidth: %u, write_bandwidth: %u\n",
>
> WARNING: __meminitdata should be placed after hmat_adist_nb
> #174: FILE: drivers/acpi/numa/hmat.c:888:
> +static __meminitdata struct notifier_block hmat_adist_nb =
>
> ERROR: that open brace { should be on the previous line
> #175: FILE: drivers/acpi/numa/hmat.c:889:
> +static __meminitdata struct notifier_block hmat_adist_nb =
> +{
>
> WARNING: From:/Signed-off-by: email name mismatch: 'From: Huang Ying <ying.huang@intel.com>' != 'Signed-off-by: "Huang, Ying" <ying.huang@intel.com>'
>
> total: 1 errors, 3 warnings, 185 lines checked
>
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
>
> ./patches/acpi-hmat-calculate-abstract-distance-with-hmat.patch has style problems, please review.
>
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
>
> Please run checkpatch prior to sending patches

Sorry, should fix that before sending.  Will do that in the future.

--
Best Regards,
Huang, Ying

> Cc: "Huang, Ying" <ying.huang@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/acpi/numa/hmat.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/drivers/acpi/numa/hmat.c~acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
> +++ a/drivers/acpi/numa/hmat.c
> @@ -885,8 +885,7 @@ static int hmat_calculate_adistance(stru
>  	return NOTIFY_STOP;
>  }
>  
> -static __meminitdata struct notifier_block hmat_adist_nb =
> -{
> +static __meminitdata struct notifier_block hmat_adist_nb = {
>  	.notifier_call = hmat_calculate_adistance,
>  	.priority = 100,
>  };
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
> swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
> fs-buffer-clean-up-block_commit_write-fix.patch
> mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
> mm-make-pte_marker_swapin_error-more-general-fix.patch
> selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
> mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
> acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
> signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

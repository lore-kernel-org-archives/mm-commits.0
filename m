Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8468C7EE24
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 11:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbjFBLl6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjFBLl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 07:41:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77728194
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 04:41:56 -0700 (PDT)
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D7C511EC0666;
        Fri,  2 Jun 2023 13:41:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1685706114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lGTr+YmAW1hK8ldPIshzArG1hVf+GX8xxRqn8WZpJd0=;
        b=merZ+g5rQ0suid+7yCeXgLr8FGWamD9I5pBS62Aw7sDTdDdof012qLxIoloC/+v7M0CevQ
        ZSUnNg+m6UN788JCYZApX4UbRspXFL9hGjjxAUEgsHyEi864fyfKc6NiHSIz5KglSHiGbQ
        te3s1BJqGm2mzHjaiP4U5KITJcno6Ng=
Date:   Fri, 2 Jun 2023 13:41:49 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com
Subject: Re: + x86-boot-compressed-handle-unaccepted-memory.patch added to
 mm-unstable branch
Message-ID: <20230602114149.GBZHnVfVejU0Qn5CoY@fat_crate.local>
References: <20230601214841.55DFAC433EF@smtp.kernel.org>
 <20230601220410.GGZHkV2juLtRq4uaJw@fat_crate.local>
 <20230601160240.ed87426e1334f649d7075bf6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601160240.ed87426e1334f649d7075bf6@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 01, 2023 at 04:02:40PM -0700, Andrew Morton wrote:
> OK, I dropped the whole series from mm-unstable.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

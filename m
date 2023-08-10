Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA57EC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHJRZs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjHJRZr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7488D211C
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11CF063592
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E970DC433C8;
        Thu, 10 Aug 2023 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691688346;
        bh=inf7s2B4XWg142kV6qHPKKBsAdYmnUwA2KFkfw9yI8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yqJ1CDuvwBi1Qv8G3bB8i7IhVzNFi5jxG3mHIWBLV2bLjFsv+PBCjAXy9oSnjvEc5
         th/fK2dzUSm3+EoGf6UR2lIc5P67SqTIzDwfyrxAxA54WFBfdIHh58mQnfT2Y62HVX
         IgDyGW+ODDU/x6dt3kYp/nE3teUT+SrHZKMfTXpM=
Date:   Thu, 10 Aug 2023 10:25:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com
Subject: Re: + mm-large_anon_folio-for-improved-performance.patch added to
 mm-unstable branch
Message-Id: <20230810102545.6a135af6009f436601c1c199@linux-foundation.org>
In-Reply-To: <279ce23c-8331-2b7c-86d3-b318f2c157af@redhat.com>
References: <20230810163130.E3D10C433C8@smtp.kernel.org>
        <279ce23c-8331-2b7c-86d3-b318f2c157af@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 10 Aug 2023 18:42:42 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 10.08.23 18:31, Andrew Morton wrote:
> > 
> > The patch titled
> >       Subject: mm: LARGE_ANON_FOLIO for improved performance
> > has been added to the -mm mm-unstable branch.  Its filename is
> >       mm-large_anon_folio-for-improved-performance.patch
> > 
> 
> It's good to give these patches some early testing in -next.
> 
> But let's wait for more review and acks before we pull this into mm-stable.
> 

OK, I thought the dust had adequately settled on this series.

I'll await the next version ;)

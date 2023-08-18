Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5157AEE4998
	for <mm-commits@archiver.kernel.org>; Fri, 18 Aug 2023 22:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbjHRWQD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Aug 2023 18:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241380AbjHRWPe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2023 18:15:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129C53C2F
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 15:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YHd5sNPDZiIVtJHdh1Kbg6YTHVjdCOzwEg6EfT1tNgo=; b=Kosj/VX++28RSmU8mjcnfEapNC
        ExNGLC7+o88nP9lZxdJAHRR5dxyGHOMU5V0lugBpaL0mJVRMKoH53l9gkxZcog/8BkoneeXMPMIeo
        iHfgNDlaU0JweW6uhpDQtW2YBCLP9zGUlESdP2wA3fNRSDFDlcRaSi7yhemL4s8GLu1SeHx6Ec2nf
        M/FTp5t2q6gI5gL3Vuv/1iCtX6ae3qAxHcxFzYwFpjn/9SmYS2TBEaw5ute1WDpQV4duCc22CkGE9
        QDpvRuHAV2n/qJJWjPUwtlo6TveOPAhxb815sd8UdCe1Y4Fc9KgNWk2J7+BXJC78VYtMS941r0kCh
        s+VReSBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qX7kh-00ByS6-0i; Fri, 18 Aug 2023 22:15:31 +0000
Date:   Fri, 18 Aug 2023 23:15:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, hughd@google.com,
        david@redhat.com, peterx@redhat.com
Subject: Re: + mm-wire-up-tail-page-poisoning-over-mappings.patch added to
 mm-unstable branch
Message-ID: <ZN/tgtMhuSFDFD6a@casper.infradead.org>
References: <20230818200031.BC269C433C9@smtp.kernel.org>
 <ZN/Uvq1qtlmK25e5@casper.infradead.org>
 <20230818140214.33027519d09c55f8f2221479@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818140214.33027519d09c55f8f2221479@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Aug 18, 2023 at 02:02:14PM -0700, Andrew Morton wrote:
> On Fri, 18 Aug 2023 21:29:50 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Fri, Aug 18, 2023 at 01:00:30PM -0700, Andrew Morton wrote:
> > > From: Peter Xu <peterx@redhat.com>
> > > Subject: mm: wire up tail page poisoning over ->mappings
> > > Date: Tue, 15 Aug 2023 17:06:59 -0400
> > 
> > Did I need to keep NAKing this patch, or did you disagree with my NAK?
> 
> This is the first time this patch has been sent out (under this title)
> and it sat on the lists unreplied-to for three days.

He didn't address my objection to the earlier one.

https://lore.kernel.org/linux-mm/ZNp7yUgUrIpILnXu@casper.infradead.org/

Anyway, I've replied to it now in *that* thread.

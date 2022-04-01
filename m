Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77384C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345648AbiDAS30 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351012AbiDAS3Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:29:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D621AC735
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 889A2B8256A
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A8AC340F3;
        Fri,  1 Apr 2022 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837653;
        bh=NnDitUPTSyFt6+/9qNIEIj8/jflifX1yuYiGrsP5PqM=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=G2KxPj+pSdTaoAB+LipCodGj8/Y2QHVMuKMTaGyhNUek/BP7LE9MamYh+MWDaN/bw
         /sQ6lLEk7b++52mroIO6Kr+4QrCAO7PCbIaOXl15nn5ePeKFMcJQxzB7fAmVw3qwhE
         eIOFPkugLiZXDpjB5SsRgtII2qH1jekY7aEh2b1I=
Date:   Fri, 1 Apr 2022 11:27:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, patches@lists.linux.dev
Subject: Re: incoming
Message-Id: <20220401112732.b2786f8684ff12dcd8b74dda@linux-foundation.org>
In-Reply-To: <20220401112026.25038467c04ea586927cb500@linux-foundation.org>
References: <20220401112026.25038467c04ea586927cb500@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Argh, messed up in-reply-to.  Let me redo...

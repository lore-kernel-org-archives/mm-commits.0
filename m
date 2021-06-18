Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E453FC48BDF
	for <mm-commits@archiver.kernel.org>; Fri, 18 Jun 2021 07:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D57613AA
	for <mm-commits@archiver.kernel.org>; Fri, 18 Jun 2021 07:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhFRH4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Jun 2021 03:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233574AbhFRH4g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Jun 2021 03:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624002867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEI/OJuAXTvuVxb5V4DRXijOpx4ZP6VR6Dmgwu8ekGM=;
        b=RW5yo5Lo1Dy1rU/2JENo3y+6+ncH0oa1kzYcfN49brt8FBE2aonmeUJkOyDI/v4LpTfpeZ
        E2zYoqvk7CNYDo//uaowiOYkwaiW2yRmgnoo8+il4YEHDrQH0NvL9gmksSdi9VS4EPiIeq
        i+FCGyM9/KkvlMSblFwBHWrI/G+s5Bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-4ZOc-eldMOu6mw9E-qvxUw-1; Fri, 18 Jun 2021 03:54:23 -0400
X-MC-Unique: 4ZOc-eldMOu6mw9E-qvxUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6F0C8186F1;
        Fri, 18 Jun 2021 07:54:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0F419D61;
        Fri, 18 Jun 2021 07:54:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210614234802.sTWMIG-eE%akpm@linux-foundation.org>
References: <20210614234802.sTWMIG-eE%akpm@linux-foundation.org>
To:     akpm@linux-foundation.org
Cc:     dhowells@redhat.com, adobriyan@gmail.com, andi@firstfloor.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: + afs-fix-tracepoint-string-placement-with-built-in-afs.patch added to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1765928.1624002859.1@warthog.procyon.org.uk>
Date:   Fri, 18 Jun 2021 08:54:19 +0100
Message-ID: <1765929.1624002859@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

I have a preferred alternative to this patch, so don't send this to Linus,
please.

Thanks,
David


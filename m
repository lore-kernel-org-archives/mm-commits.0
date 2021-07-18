Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A037C636C8
	for <mm-commits@archiver.kernel.org>; Sun, 18 Jul 2021 22:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 417D16113D
	for <mm-commits@archiver.kernel.org>; Sun, 18 Jul 2021 22:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhGRWhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Jul 2021 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRWhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Jul 2021 18:37:19 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060E4C061762
        for <mm-commits@vger.kernel.org>; Sun, 18 Jul 2021 15:34:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GSfsX6WWGz9sSs;
        Mon, 19 Jul 2021 08:34:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626647652;
        bh=nYoJ9YDk9wALKdB3DTYdG6GpF3mT7FQ9BYJF0Qn9Lwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ikds2dKbB2HBGHbDL2KGjfeoQg2lIxdZcUlWuURf/jt5ug2HIKda1V0XqYKanyLKA
         DFRTveZN39wHBa4U2LQ/aembPaT5KG5MfLBNWzoa6HFd01n/9an/j8OwF4h8RlDbgl
         7cGmebA8XgM023SZ6WzUo3MegsOUadfNEsmZ5WoQkGGzBOe+0eDqraXtBVejHRO3xk
         fcc58eSCA7LkZFjKGqn3I8HLQwIbcz8vT0GHPigaitOSqy7XjA6I9gZ36LR+W4Dsza
         AENCfn84XG62FhfJ7hJotoYDnr+qH0t/vGlIzTy6y+shKY4rKJj0cAL1arY3YwPcn7
         nXZ11NudncgIg==
Date:   Mon, 19 Jul 2021 08:34:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        m.szyprowski@samsung.com, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, tj@kernel.org, yangyingliang@huawei.com,
        ying.huang@intel.com
Subject: Re: + memcg-infrastructure-to-flush-memcg-stats-v5.patch added to
 -mm tree
Message-ID: <20210719083341.37d58cfd@elm.ozlabs.ibm.com>
In-Reply-To: <20210716230409.ihUziw7UR%akpm@linux-foundation.org>
References: <20210716230409.ihUziw7UR%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/do5RZnCxQ5HHX+=ZnzkHGdX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/do5RZnCxQ5HHX+=ZnzkHGdX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Jul 2021 16:04:09 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: memcg-infrastructure-to-flush-memcg-stats-v5
> has been added to the -mm tree.  Its filename is
>      memcg-infrastructure-to-flush-memcg-stats-v5.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/do5RZnCxQ5HHX+=ZnzkHGdX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD0rF8ACgkQAVBC80lX
0GwAaAf/aFfeFhsrKc5ZuZl7QdcC8SVz4lbTOt9RhCvUneWSGMQ1OUziP2R3K0Wk
WhmEhbH2KjL9/6BE7f36Oj2LOWpfwmfI3V/t3F/LG8zJlFAv/GkJXrZhfZ1LSaEm
DhjFQfkGQ/DFXerrz+RoChK95fWMbfixWIA23arjjP1ZC6Iea1kN7FXxowpL3iIJ
jCE4QqWOt8uCEhC4eTe3pOZZS7yvYHSff4/KjHr2tXWJjAbMIeotRlIOblFv+RNd
waGvaFUnkRy0xXJaWcRIAu+gmbWQXdGgfC05F5VmTCW8Z/Da0Vttt4BJp/r01XU1
Gagmy/lSYPN7lQKDZeHvr6Nc3f0bLQ==
=fzNd
-----END PGP SIGNATURE-----

--Sig_/do5RZnCxQ5HHX+=ZnzkHGdX--

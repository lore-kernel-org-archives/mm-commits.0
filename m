Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2BDC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 05:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhLHFrf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 00:47:35 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:34863 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhLHFre (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 00:47:34 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J85gl61tkz4xgr;
        Wed,  8 Dec 2021 16:43:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638942234;
        bh=wd4qeRgu02DVA598IUL+Q3bWu4tvaqm6LthSMJIq9Og=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J/JnqwxUZmJ7oCwpiw939gQXiHvaSVK9TPtifuyiKKiZOGCtD3Nk9eZjDZOLKycMO
         yhwiEcOFJM3Eh7KGFPsfJdDaAipQKL2bE0rKVTJewrewyYZjKssEJZK9hPYLJHwwR1
         l6HBV56kdLCy+spLLMpjPBnJF93hqBPBDKvY0UgWr6pvhhTgcS2coR2n4kEgOv1KXv
         8zgBlyAmAV1SfyCoi1UxxLhFLEjq5iBDPxvSE1id90Zf+LniOGUGLQMsD/U3V8o+ha
         bEidxqUQ0wCR//RpG25nZ4ii3IWjPVaI4Jjie/i1MgPCqYktUY/tCk9qftMKKJ1MVK
         c+hrqURmvPc2Q==
Date:   Wed, 8 Dec 2021 16:43:47 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, ccross@google.com, ebiederm@xmission.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, surenb@google.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org,
        yuzhao@google.com
Subject: Re: + mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch added
 to -mm tree
Message-ID: <20211208164347.1149efe0@canb.auug.org.au>
In-Reply-To: <20211208001134.Ki-xRAxki%akpm@linux-foundation.org>
References: <20211208001134.Ki-xRAxki%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NtI.Sr9z0ll4F.OwEtPGi1W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/NtI.Sr9z0ll4F.OwEtPGi1W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 07 Dec 2021 16:11:34 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm: move anon_vma declarations to linux/mm_inline.h
> has been added to the -mm tree.  Its filename is
>      mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/NtI.Sr9z0ll4F.OwEtPGi1W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGwRhMACgkQAVBC80lX
0GyD3wf+PlqLO96d6+mM5lsZK5CxGtQ7dMw9JxjqshekpETFD6KHt09rIrymUKbR
zH2VvIFAZjgBeRt/0+XXejBWaISPBUtTdrqDlfpKvLQS36PrGs3Wh098JkO0GpMA
HpY7LkPd+rysRUQqcIh5YYfZcpJhb6hE+oDnsh/9AKu2JtevlxSouh5D1Oj0rvhO
fiqnROvU+4h91X4x5nDi1PTnGhrhYSfmF0MEB7nuFjV43vJhyoPr9lvAq3/HYDJG
LT09beI5BvxalQTUaNwVsxs6MxwNrOgnxyfz34yV5C/nvrED6EqP+nCXqr4VU8eU
btNduAKp+miZZACFw2lgWMTKOLi/UQ==
=IV2S
-----END PGP SIGNATURE-----

--Sig_/NtI.Sr9z0ll4F.OwEtPGi1W--

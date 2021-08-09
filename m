Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5224C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 22:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F506054F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 22:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHIWNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 18:13:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57489 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234382AbhHIWNU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 18:13:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gk9Lm3ktJz9sX5;
        Tue, 10 Aug 2021 08:12:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628547178;
        bh=P47RCmbwRnmZ5oX7RxHWtBPdXbC4bY65O7weeZiq8Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pFKykRVpAw2m6afq4fFVC36k3bfntao/wBi2JS0sdKIV6rUblJlTQvt6zTMUmt8wk
         LC27hysS8TZMDhSTQXcQXXFwKW29giwOs0a/3EO+EB9pgMbsw61H8xuCbexdYYYDy6
         3PfayP7DQ3xXRl9UbG/0X9cSnUb0JfKpq6I6dCamw7AXCVbSSlbOU578Y9wG+Z+hn+
         wF+JLXjXpG6n9dHnCLljABVKhlPqP6IC02XHeqb/1cjVWiF2FHVVa+o062gYt4H/m0
         JRCzHi4LXM5vgVuP3bCz2by8vDZlMzQPKIdmXfiQllOLoGRkKmFfrDUe1k9j4uYieD
         3wwQLOMrt9MNg==
Date:   Tue, 10 Aug 2021 08:12:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, robh+dt@kernel.org,
        rmk+kernel@armlinux.org.uk, rafael.j.wysocki@intel.com,
        peterz@infradead.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        mingo@redhat.com, mick@ics.forth.gr, maz@kernel.org,
        luto@kernel.org, lenb@kernel.org, kirill@shutemov.name,
        hpa@zytor.com, hca@linux.ibm.com, gregkh@linuxfoundation.org,
        gor@linux.ibm.com, frowand.list@gmail.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@de.ibm.com, aou@eecs.berkeley.edu, rppt@linux.ibm.com
Subject: Re: [failures]
 memblock-make-memblock_find_in_range-method-private.patch removed from -mm
 tree
Message-ID: <20210810081207.339f17bd@elm.ozlabs.ibm.com>
In-Reply-To: <20210809193641.BY7Ys%akpm@linux-foundation.org>
References: <20210809193641.BY7Ys%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=dzwn1DfRYKakOHT1ncR92k";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/=dzwn1DfRYKakOHT1ncR92k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 09 Aug 2021 12:36:41 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: memblock: make memblock_find_in_range method private
> has been removed from the -mm tree.  Its filename was
>      memblock-make-memblock_find_in_range-method-private.patch
>=20
> This patch was dropped because it had testing failures

Removed from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/=dzwn1DfRYKakOHT1ncR92k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmERqF8ACgkQAVBC80lX
0GyK9gf+IGYK5E7y5RE06dTvbtr8T4js6efWtKMpBN/jg/xKF6rtmTJTCopyDnwC
rG+QeiRB+SNtK1jAnHxex4fsCp9AXmTwndVj8ICCktgwn7j3sNCfdK/lIXPj65CK
ASN0q355gh/2BpW3bEpyt1oEM3pDUSon4w7QVm+d0km58SIEemUzOWdADxh829lU
QaIkiCuteOtDZZqsWOGrvNPHI2P3kiA7BhUQrU4At+Tw5tbTUuS3D0HbKQv0V8UA
996kd58j/itVLO1/t1JRdry0wGZhK1kNyyU0nPduzD9w3BzeGRlfJ2Uv8RLldEgY
lECdv6cqW1Pt7LdeWErYMaLVH6zAwA==
=4xcQ
-----END PGP SIGNATURE-----

--Sig_/=dzwn1DfRYKakOHT1ncR92k--
